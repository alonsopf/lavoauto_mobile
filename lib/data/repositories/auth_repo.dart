import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../utils/utils.dart';
import '../data_sources/remote/api_endpoint_urls.dart';
import '../models/request/auth/login_modal.dart';
import '../models/request/auth/forgot_password_modal.dart';
import '../models/request/user/register_modal.dart';

import '../data_sources/remote/api_client.dart';
import '../models/request/worker/register_modal.dart';
import '../models/response/auth/login_respose_modal.dart';
import '../models/response/auth/forget_password_response_modal.dart';
import '../models/response/auth/user_registeration_response.dart';
import '../models/response/auth/user_worker_info_modal.dart';
import '../models/response/worker/registeration_response_modal.dart';
import '../models/response/auth/profile_image_response_modal.dart';
import '../models/response/location/location_response_modal.dart';
import '../models/request/auth/delete_account_modal.dart';
import '../models/response/auth/delete_account_response_modal.dart';
import '../models/api_response.dart';

@injectable
class AuthRepo extends ApiClient {
  /// Register a new user (client) using the RegisterRequest model
  Future<ApiResponse<UserRegistrationResponse>> registerUser(
      RegisterRequest body) async {
    try {
      final response = await postService(
        ApiEndpointUrls.signup_,
        body.toJson(),
        contextType: true,
      );

      if (response != null) {
        var response_ = jsonDecode(response.body);

        if (response_['cliente_id'] != null) {
          return ApiResponse(
              data: UserRegistrationResponse.fromJson(response_));
        } else {
          // Check for both 'error' and 'message' fields
          String errorMessage = response_['error'] ?? 
                                response_['message'] ?? 
                                'Registration failed';
          return ApiResponse(errorMessage: errorMessage);
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in registerUser: $e");
      }
      return ApiResponse(errorMessage: 'An unexpected error occurred: $e');
    }
  }

  /// Register a new worker (lavador) using the RegisterLavadorRequest model
  Future<ApiResponse<UserRegistrationResponse>> registerWorker(
      RegisterLavadorRequest body) async {
    try {
      final response = await postService(
        ApiEndpointUrls.signupWorker_,
        body.toJson(),
        contextType: true,
      );

      if (response != null) {
        var response_ = jsonDecode(response.body);

        if (response_['lavador_id'] != null) {
          return ApiResponse(
              data: UserRegistrationResponse.fromJson(response_));
        } else {
          // Check for both 'error' and 'message' fields
          String errorMessage = response_['error'] ?? 
                                response_['message'] ?? 
                                'Registration failed';
          return ApiResponse(errorMessage: errorMessage);
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in registerWorker: $e");
      }
      return ApiResponse(errorMessage: 'An unexpected error occurred: $e');
    }
  }

  /// Upload profile photo (base64 image)
  Future<ApiResponse<ProfileImageResponse>> uploadProfilePhoto(
      String imageBase64, String contentType) async {
    try {
      debugPrint("🔧 Using postImageService for upload with contentType: '$contentType'");
      
      final response = await postImageService(
        ApiEndpointUrls.uploadProfile,
        imageBase64,
        contentType,
      );

      if (response != null) {
        debugPrint("🔍 Raw response status: ${response.statusCode}");
        debugPrint("🔍 Raw response body: ${response.body}");
        
        var response_ = jsonDecode(response.body);
        debugPrint("🔍 Parsed response: $response_");

        if (response_['image_url'] != null) {
          debugPrint("✅ Found image_url in response: ${response_['image_url']}");
          final profileResponse = ProfileImageResponse.fromJson(response_);
          debugPrint("✅ Created ProfileImageResponse: ${profileResponse.imageUrl}");
          return ApiResponse(data: profileResponse);
        } else {
          debugPrint("❌ No image_url found in response");
          return ApiResponse(
              errorMessage: response_['message'] ?? 'Image upload failed');
        }
      } else {
        debugPrint("❌ Response is null");
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      if (kDebugMode) {
        print("💥 Error in uploadProfilePhoto: $e");
      }
      return ApiResponse(errorMessage: 'An unexpected error occurred: $e');
    }
  }

  /// Get locations by zipcode
  Future<ApiResponse<LocationResponse>> getLocationsByZipcode(
      String zipcode) async {
    try {
      final response = await getService("${ApiEndpointUrls.zipCode_}$zipcode");

      if (response != null) {
        var response_ = jsonDecode(response.body);
        return ApiResponse(data: LocationResponse.fromJson(response_));
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in getLocationsByZipcode: $e");
      }
      return ApiResponse(errorMessage: 'An unexpected error occurred: $e');
    }
  }

  /// Get login user and worker
  Future<ApiResponse<LoginResponse>> login(LoginRequest body) async {
    try {
      final response = await postService(
        ApiEndpointUrls.login_,
        body.toJson(),
        contextType: true,
      );

      if (response != null) {
        var response_ = jsonDecode(response.body);

        if (response_['token'] != null) {
          return ApiResponse(data: LoginResponse.fromJson(response_));
        } else {
          // Check for both 'error' and 'message' fields for login errors
          String errorMessage = response_['error'] ?? 
                                response_['message'] ?? 
                                'Login failed';
          return ApiResponse(errorMessage: errorMessage);
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in loginUser: $e");
      }
      return ApiResponse(errorMessage: 'An unexpected error occurred: $e');
    }
  }

  /// Get user worker info

  Future<ApiResponse<UserWorkerInfoResponse>> getUserWorkerInfo({String? token}) async {
    try {
      final response = await getService("${ApiEndpointUrls.userInfo}$token");

      if (response != null) {
        var response_ = jsonDecode(response.body);
        return ApiResponse(data: UserWorkerInfoResponse.fromJson(response_));
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in getUserWorkerInfo: $e");
      }
      return ApiResponse(errorMessage: 'An unexpected error occurred: $e');
    }
  }

  /// Reset password using email
  Future<ApiResponse<ForgetPasswordResponse>> forgotPassword(ForgotPasswordRequest body) async {
    try {
      final response = await postService(
        ApiEndpointUrls.resetPassword_,
        body.toJson(),
        contextType: true,
      );

      if (response != null) {
        var response_ = jsonDecode(response.body);
        
        if (response_['message'] != null || response.statusCode == 200) {
          return ApiResponse(data: ForgetPasswordResponse.fromJson(response_));
        } else {
          String errorMessage = response_['error'] ?? 
                                response_['message'] ?? 
                                'Password reset failed';
          return ApiResponse(errorMessage: errorMessage);
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in forgotPassword: $e");
      }
      return ApiResponse(errorMessage: 'An unexpected error occurred: $e');
    }
  }

  /// Delete user account permanently
  Future<ApiResponse<DeleteAccountResponse>> deleteAccount(DeleteAccountRequest body) async {
    try {
      final response = await postService(
        ApiEndpointUrls.deleteAccount,
        body.toJson(),
        contextType: true,
      );

      if (response != null) {
        var response_ = jsonDecode(response.body);
        
        if (response_['message'] != null || response.statusCode == 200) {
          return ApiResponse(data: DeleteAccountResponse.fromJson(response_));
        } else {
          String errorMessage = response_['error'] ?? 
                                response_['message'] ?? 
                                'Account deletion failed';
          return ApiResponse(errorMessage: errorMessage);
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in deleteAccount: $e");
      }
      return ApiResponse(errorMessage: 'An unexpected error occurred: $e');
    }
  }

  /// Update client profile information
  Future<ApiResponse<Map<String, dynamic>>> updateClienteProfile({
    required String token,
    String? calle,
    String? numeroExterior,
    String? numeroInterior,
    String? colonia,
    String? ciudad,
    String? estado,
    String? codigoPostal,
    double? lat,
    double? lng,
    String? fotoUrl,
  }) async {
    try {
      final body = {
        'token': token,
        'calle': calle ?? '',
        'numero_exterior': numeroExterior ?? '',
        'numero_interior': numeroInterior ?? '',
        'colonia': colonia ?? '',
        'ciudad': ciudad ?? '',
        'estado': estado ?? '',
        'codigo_postal': codigoPostal ?? '',
        'lat': lat ?? 0.0,
        'lng': lng ?? 0.0,
        'foto_url': fotoUrl ?? '',
      };

      final response = await postService(
        ApiEndpointUrls.lavoauto_update_cliente,
        body,
        contextType: true,
      );

      if (response != null) {
        var response_ = jsonDecode(response.body);

        if (response_['message'] != null || response.statusCode == 200) {
          return ApiResponse(data: response_);
        } else {
          String errorMessage = response_['error'] ??
                                response_['message'] ??
                                'Profile update failed';
          return ApiResponse(errorMessage: errorMessage);
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in updateClienteProfile: $e");
      }
      return ApiResponse(errorMessage: 'An unexpected error occurred: $e');
    }
  }
}
