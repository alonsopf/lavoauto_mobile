part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthInitialEvent extends AuthEvent {
  const AuthInitialEvent();
  @override
  List<Object?> get props => [];
}

class LocationEvent extends AuthEvent {
  final String? postalCode;
  final bool isUser;
  const LocationEvent({this.postalCode, this.isUser = false});
  @override
  List<Object?> get props => [postalCode, isUser];
}

class UpdateServiceEvent extends AuthEvent {
  final bool isTransport, isWasher;
  const UpdateServiceEvent({this.isTransport = false, this.isWasher = false});
  @override
  List<Object?> get props => [isTransport, isWasher];
}

class GetProfileUrlEvent extends AuthEvent {
  final XFile profileImage;
  final bool isUser;
  const GetProfileUrlEvent({required this.profileImage, this.isUser = false});
  @override
  List<Object?> get props => [profileImage, isUser];
}

class RegistrationEvent extends AuthEvent {
  final bool isUser;
  final bool? isProfileSelected;
  final RegisterRequest? userRegistrationModel;
  final RegisterLavadorRequest? workerRegistrationModel;
  final XFile? profileImage;
  const RegistrationEvent(
      {required this.isUser,
      this.isProfileSelected,
      this.userRegistrationModel,
      this.workerRegistrationModel,
      this.profileImage});

  @override
  List<Object?> get props => [
        isUser,
        isProfileSelected,
        userRegistrationModel,
        workerRegistrationModel,
        profileImage
      ];
}

class UpdateKeepSessionOn extends AuthEvent {
  final bool iskeepsessionOn;
  const UpdateKeepSessionOn({this.iskeepsessionOn = false});
  @override
  List<Object?> get props => [iskeepsessionOn];
}

class UserLoginEvent extends AuthEvent {
  final LoginRequest loginRequest;
  const UserLoginEvent({required this.loginRequest});
  @override
  List<Object?> get props => [loginRequest];
}
