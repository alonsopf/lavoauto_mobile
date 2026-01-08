import 'package:json_annotation/json_annotation.dart';

part 'login_modal.g.dart';

@JsonSerializable()
class LoginRequest {
  /// User email address
  final String email;

  /// User password
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  /// Converts the LoginRequest instance to a JSON map
  ///
  ///

  /// Custom `toJson` method to include the static `path` and nest the model under `body`
  Map<String, dynamic> toJson() => {
        "path": "/login", // Static path
        "body": _$LoginRequestToJson(this), // Serialize the model under "body"
      };
}
