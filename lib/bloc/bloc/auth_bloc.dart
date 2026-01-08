import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lavoauto/data/models/response/auth/user_worker_info_modal.dart';
import 'package:lavoauto/data/models/response/location/location_response_modal.dart';
import 'package:lavoauto/data/repositories/auth_repo.dart';
import 'package:lavoauto/data/repositories/chat_repository.dart';
import 'package:lavoauto/services/push_notification_service.dart';
import 'package:lavoauto/utils/image_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

import '../../data/models/request/auth/login_modal.dart';
import '../../data/models/request/user/register_modal.dart';
import '../../data/models/request/worker/register_modal.dart';

import '../../data/models/response/auth/login_respose_modal.dart';
import '../../data/models/response/auth/user_registeration_response.dart';
import '../../data/models/response/auth/profile_image_response_modal.dart';
import '../../utils/utils.dart';
import '../../data/models/api_response.dart';
import '../../dependencyInjection/di.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo authRepository;
  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<RegistrationEvent>(registration);
    on<LocationEvent>(fetchLocation);
    on<GetProfileUrlEvent>(fetchProfileImageUrl);

    on<UpdateServiceEvent>(updateServiceEvent);
    on<AuthInitialEvent>((event, emit) {
      emit(AuthInitial());
    });

    on<UpdateKeepSessionOn>(updateKeepSessionOn);
    on<UserLoginEvent>(userLoginEvent);
  }

  userLoginEvent(UserLoginEvent event, Emitter<AuthState> emit) async {
    // emit(AuthLoginLoadingState());
    try {
      var currentState = state;
      currentState = currentState is AuthLoginSuccessState
          ? currentState
          : const AuthLoginSuccessState(
              userWorkerInfo: null, token: null, keepSessionOpen: false);
      emit(AuthLoginLoadingState());
      ApiResponse? response = await authRepository.login(event.loginRequest);
      if (response.data != null) {
        LoginResponse? loginResponse = response.data as LoginResponse?;
        debugPrint("User Login Response: ${loginResponse?.toJson()}");

        ApiResponse? userinfInfoResponse =
            await authRepository.getUserWorkerInfo(token: loginResponse?.token);
        if (userinfInfoResponse.data != null) {
          UserWorkerInfoResponse? userWorkerInfo =
              userinfInfoResponse.data as UserWorkerInfoResponse?;
          debugPrint("User Worker Info Response: ${userWorkerInfo?.toJson()}");

          String userTypeToSave = userWorkerInfo?.userType.toString().toLowerCase() ?? '';
          debugPrint("🔐 Login - Saving userType: '$userTypeToSave' from API response: '${userWorkerInfo?.userType}'");
          await Utils.setAuthenticationToken(loginResponse?.token, userTypeToSave);

          // Register device token for push notifications (non-blocking)
          _registerDeviceTokenAsync(loginResponse?.token);

          if (state is AuthLoginSuccessState) {
            final currentState = state as AuthLoginSuccessState;
            emit(currentState.copyWith(
                userWorkerInfo: userWorkerInfo,
                token: loginResponse?.token,
                keepSessionOpen: currentState.keepSessionOpen));
            return;
          }
          emit(AuthLoginSuccessState(
              userWorkerInfo: userWorkerInfo,
              token: loginResponse?.token,
              keepSessionOpen: currentState.keepSessionOpen));
        } else {
          emit(AuthLoginFailure(
              error: userinfInfoResponse.errorMessage ??
                  "Failed to fetch user worker info"));
        }
      } else {
        emit(AuthLoginFailure(
            error: response.errorMessage ?? "Failed to login user"));
      }
    } catch (e) {
      emit(AuthLoginFailure(error: e.toString()));
    }
  }

  updateKeepSessionOn(UpdateKeepSessionOn event, Emitter<AuthState> emit) {
    if (state is AuthLoginSuccessState) {
      final currentState = state as AuthLoginSuccessState;
      emit(currentState.copyWith(keepSessionOpen: event.iskeepsessionOn));
    } else {
      emit(AuthLoginSuccessState(keepSessionOpen: event.iskeepsessionOn));
    }
  }

  updateServiceEvent(UpdateServiceEvent event, Emitter<AuthState> emit) {
    if (state is AuthRegistrationSuccess) {
      final currentState = state as AuthRegistrationSuccess;
      emit(currentState.copyWith(
          isTransport: event.isTransport, isWasher: event.isWasher));
    } else {
      emit(AuthRegistrationSuccess(
          isUser: true,
          isTransport: event.isTransport,
          isWasher: event.isWasher));
    }
  }

  fetchLocation(LocationEvent event, Emitter<AuthState> emit) async {
    try {
      ApiResponse? locationResponse = await authRepository
          .getLocationsByZipcode(event.postalCode.toString());
      if (locationResponse.data != null) {
        if (state is AuthRegistrationSuccess) {
          final currentState = state as AuthRegistrationSuccess;
          debugPrint(
              "User Registration Response: ${locationResponse.data?.toJson()}");
          emit(currentState.copyWith(
              isUser: event.isUser, locationResponse: locationResponse.data));
          return;
        }
        emit(AuthRegistrationSuccess(
            isUser: event.isUser, locationResponse: locationResponse.data));
      } else {
        emit(const AuthRegistrationFailure(error: "Failed to fetch location"));
      }
    } catch (_) {
      emit(const AuthRegistrationFailure(error: "Failed to fetch location"));
    }
  }

  fetchProfileImageUrl(
      GetProfileUrlEvent event, Emitter<AuthState> emit) async {
    try {
      AuthRegistrationSuccess? currentState;
      if (state is AuthRegistrationSuccess) {
        currentState = state as AuthRegistrationSuccess;
      }

      emit(AuthRegistrationLoading());

      // 1. Process and save image locally (resize to 512x512 and save)
      debugPrint("🖼️ Processing and saving profile image locally...");
      final localPath = await ImageUtils.processAndSaveProfileImage(event.profileImage);
      debugPrint("✅ Image saved locally at: $localPath");

      // 2. Upload resized image to server
      final localFile = File(localPath);
      String imageBase64 = await ImageUtils.imageToBase64(localFile);
      String contentType = ImageUtils.getContentType(localPath);
      // contentType = 'image/jpeg';
      debugPrint("📤 Uploading image to server:");
      debugPrint("   - File path: $localPath");
      debugPrint("   - Content type: '$contentType'");
      debugPrint("   - File size: ${await localFile.length()} bytes");
      debugPrint("   - Base64 length: ${imageBase64.length} chars");
      // Safely get substring with proper bounds checking
      final previewLength = imageBase64.length > 50 ? 50 : imageBase64.length;
      if (previewLength > 0) {
        debugPrint("   - First $previewLength chars of base64: ${imageBase64.substring(0, previewLength)}...");
      }
      debugPrint("🔍 About to call uploadProfilePhoto with contentType: '$contentType'");
      
      final ApiResponse<ProfileImageResponse> uploadResponse = 
          await authRepository.uploadProfilePhoto(imageBase64, contentType);
      
      debugPrint("🔍 Upload response received:");
      debugPrint("   - uploadResponse.data: ${uploadResponse.data}");
      debugPrint("   - uploadResponse.errorMessage: ${uploadResponse.errorMessage}");
      
      if (uploadResponse.data != null) {
        debugPrint("✅ Photo uploaded successfully: ${uploadResponse.data!.imageUrl}");
        
        // Handle state update properly
        if (currentState != null) {
          // Update existing AuthRegistrationSuccess state
          emit(currentState.copyWith(
            isUser: currentState.isUser,
            profileImageUrl: uploadResponse.data!.imageUrl,
            userRegistrationModel: currentState.userRegistrationModel,
            workerRegistrationModel: currentState.workerRegistrationModel,
            profileImage: event.profileImage,
            localImagePath: localPath, // Store local path in state
          ));
        } else {
          // Create new AuthRegistrationSuccess state
          emit(AuthRegistrationSuccess(
            isUser: event.isUser,
            profileImageUrl: uploadResponse.data!.imageUrl,
            profileImage: event.profileImage,
            localImagePath: localPath,
          ));
        }
      } else {
        debugPrint("❌ Photo upload failed: ${uploadResponse.errorMessage}");
        emit(AuthRegistrationFailure(
            error: uploadResponse.errorMessage ?? "Failed to upload profile image"));
      }
    } catch (e) {
      debugPrint("💥 Error uploading profile image: $e");
      emit(AuthRegistrationFailure(
          error: "Failed to upload profile image: $e"));
    }
  }

  registration(RegistrationEvent event, Emitter<AuthState> emit) async {
    // emit(AuthRegistrationLoading());
    try {
      // Simulate a registration process
      if (event.userRegistrationModel != null ||
          event.workerRegistrationModel != null) {
        ApiResponse? response = event.isUser
            ? await authRepository.registerUser(event.userRegistrationModel!)
            : await authRepository
                .registerWorker(event.workerRegistrationModel!);
        if (response.data != null) {
          UserRegistrationResponse? userRegistrationResponse =
              response.data as UserRegistrationResponse?;
          debugPrint(
              "User Registration Response: ${userRegistrationResponse?.toJson()}");
          
          if (state is AuthRegistrationSuccess) {
            final currentState = state as AuthRegistrationSuccess;
            emit(currentState.copyWith(
                isUser: event.isUser,
                userRegistrationResponse: userRegistrationResponse));
          } else {
            // Create new success state if current state is not AuthRegistrationSuccess
            emit(AuthRegistrationSuccess(
                isUser: event.isUser,
                userRegistrationResponse: userRegistrationResponse,
                profileImage: event.profileImage,
                userRegistrationModel: event.userRegistrationModel,
                workerRegistrationModel: event.workerRegistrationModel));
          }
          return;
        } else {
          emit(AuthRegistrationFailure(
              error: response.errorMessage ?? "Failed to register user"));
        }
        return;
      }
      if (state is AuthRegistrationSuccess) {
        final currentState = state as AuthRegistrationSuccess;
        emit(currentState.copyWith(
          isUser: currentState.isUser,
          userRegistrationModel: currentState.userRegistrationModel,
          workerRegistrationModel: currentState.workerRegistrationModel,
          profileImage: event.profileImage ?? currentState.profileImage,
        ));
      } else {
        emit(AuthRegistrationSuccess(
            isUser: event.isUser,
            profileImage: event.profileImage,
            userRegistrationModel: event.userRegistrationModel,
            workerRegistrationModel: event.workerRegistrationModel));
      }
    } catch (e) {
      emit(AuthRegistrationFailure(error: e.toString()));
    }
  }

  /// Registers device token for push notifications in the background
  /// Non-blocking operation - errors are logged but don't affect login flow
  void _registerDeviceTokenAsync(String? token) async {
    if (token == null) {
      debugPrint("⚠️ Cannot register device token: auth token is null");
      return;
    }

    try {
      debugPrint("🔔 Initializing push notification service for auth...");
      final pushService = PushNotificationService();

      // Use simplified initialization method that handles everything
      await pushService.initializeForAuth(token);

      debugPrint("✅ Push notification service initialized successfully!");
    } catch (e, stackTrace) {
      debugPrint("❌ Error initializing push notifications: $e");
      debugPrint("Stack trace: $stackTrace");
      // Don't throw - this is a non-critical background operation
    }
  }

}
