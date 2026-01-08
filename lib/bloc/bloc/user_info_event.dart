part of 'user_info_bloc.dart';

sealed class UserInfoEvent extends Equatable {
  const UserInfoEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserProfileInfoEvent extends UserInfoEvent {
  final String? token;

  const FetchUserProfileInfoEvent({this.token});

  @override
  List<Object?> get props => [token];
}