import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../data/models/response/auth/user_worker_info_modal.dart';
import '../../data/repositories/auth_repo.dart';
import '../../data/models/api_response.dart';

part 'user_info_event.dart';
part 'user_info_state.dart';

class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  final AuthRepo authRepository;
  UserInfoBloc({required this.authRepository}) : super(UserInfoInitial()) {
    on<FetchUserProfileInfoEvent>(fetchUserProfileInfoEvent);
  }

  fetchUserProfileInfoEvent(
      FetchUserProfileInfoEvent event, Emitter<UserInfoState> emit) async {
    ApiResponse? userinfInfoResponse =
        await authRepository.getUserWorkerInfo(token: event.token);
    if (userinfInfoResponse.data != null) {
      UserWorkerInfoResponse? userWorkerInfo =
          userinfInfoResponse.data as UserWorkerInfoResponse?;
      debugPrint("User Worker Info Response: ${userWorkerInfo?.toJson()}");
      if (state is UserInfoSuccess) {
        final currentState = state as UserInfoSuccess;
        emit(currentState.copyWith(userWorkerInfo: userWorkerInfo));
      } else {
        emit(UserInfoSuccess(userWorkerInfo: userWorkerInfo));
      }
    } else {
      emit(UserInfoFailure(
          error: userinfInfoResponse.errorMessage ??
              "Failed to fetch user worker info"));
    }
  }
}
