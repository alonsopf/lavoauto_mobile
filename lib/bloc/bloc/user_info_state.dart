part of 'user_info_bloc.dart';

sealed class UserInfoState extends Equatable {
  const UserInfoState();

  @override
  List<Object?> get props => [];
}

final class UserInfoInitial extends UserInfoState {}

final class UserInfoLoading extends UserInfoState {}

final class UserInfoSuccess extends UserInfoState {
  final UserWorkerInfoResponse? userWorkerInfo;

  const UserInfoSuccess({this.userWorkerInfo});
  UserInfoSuccess copyWith({UserWorkerInfoResponse? userWorkerInfo}) {
    return UserInfoSuccess(
        userWorkerInfo: userWorkerInfo ?? this.userWorkerInfo);
  }

  @override
  List<Object?> get props => [userWorkerInfo];
}

final class UserInfoFailure extends UserInfoState {
  final String error;

  const UserInfoFailure({required this.error});

  @override
  List<Object> get props => [error];
}
