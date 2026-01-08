import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_modal.g.dart';

@JsonSerializable()
class ForgotPasswordRequest {
  /// User email address
  final String email;

  ForgotPasswordRequest({
    required this.email,
  });

  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordRequestFromJson(json);

  /// Custom `toJson` method to include the static `path` and nest the model under `body`
  Map<String, dynamic> toJson() => {
        "path": "/remember-password", // Static path
        "body": _$ForgotPasswordRequestToJson(this), // Serialize the model under "body"
      };
} 