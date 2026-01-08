part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthInitialLoading extends AuthState {}

final class AuthRegistrationLoading extends AuthState {}

final class AuthRegistrationSuccess extends AuthState {
  final bool isUser;
  final RegisterRequest? userRegistrationModel;
  final RegisterLavadorRequest? workerRegistrationModel;
  final XFile? profileImage;
  final String? profileImageUrl;
  final String? localImagePath;
  final LocationResponse? locationResponse;
  final UserRegistrationResponse? userRegistrationResponse;
  final bool? isTransport, isWasher;
  const AuthRegistrationSuccess(
      {required this.isUser,
      this.userRegistrationModel,
      this.workerRegistrationModel,
      this.locationResponse,
      this.profileImageUrl,
      this.localImagePath,
      this.userRegistrationResponse,
      this.isTransport = false,
      this.isWasher = false,
      this.profileImage});
  copyWith(
      {bool? isUser,
      RegisterRequest? userRegistrationModel,
      RegisterLavadorRequest? workerRegistrationModel,
      XFile? profileImage,
      LocationResponse? locationResponse,
      bool? isTransport,
      bool? isWasher,
      UserRegistrationResponse? userRegistrationResponse,
      String? profileImageUrl,
      String? localImagePath}) {
    return AuthRegistrationSuccess(
        isUser: isUser ?? this.isUser,
        isWasher: isWasher ?? this.isWasher,
        userRegistrationResponse:
            userRegistrationResponse ?? this.userRegistrationResponse,
        locationResponse: locationResponse ?? this.locationResponse,
        userRegistrationModel:
            userRegistrationModel ?? this.userRegistrationModel,
        workerRegistrationModel:
            workerRegistrationModel ?? this.workerRegistrationModel,
        profileImage: profileImage ?? this.profileImage,
        isTransport: isTransport ?? this.isTransport,
        profileImageUrl: profileImageUrl ?? this.profileImageUrl,
        localImagePath: localImagePath ?? this.localImagePath);
  }

  @override
  List<Object?> get props => [
        isUser,
        userRegistrationModel,
        locationResponse,
        workerRegistrationModel,
        profileImage,
        profileImageUrl,
        localImagePath,
        userRegistrationResponse,
        isTransport,
        isWasher
      ];
}

final class AuthRegistrationFailure extends AuthState {
  final String error;

  const AuthRegistrationFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

final class AuthLoginLoadingState extends AuthState {}

final class AuthLoginSuccessState extends AuthState {
  final UserWorkerInfoResponse? userWorkerInfo;
  final String? token;
  final bool keepSessionOpen;

  const AuthLoginSuccessState(
      {this.userWorkerInfo, this.token, this.keepSessionOpen = false});

  AuthLoginSuccessState copyWith({
    UserWorkerInfoResponse? userWorkerInfo,
    String? token,
    bool? keepSessionOpen,
  }) {
    return AuthLoginSuccessState(
      userWorkerInfo: userWorkerInfo ?? this.userWorkerInfo,
      token: token ?? this.token,
      keepSessionOpen: keepSessionOpen ?? this.keepSessionOpen,
    );
  }

  @override
  List<Object?> get props => [userWorkerInfo, token, keepSessionOpen];
}

final class AuthLoginFailure extends AuthState {
  final String error;

  const AuthLoginFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
