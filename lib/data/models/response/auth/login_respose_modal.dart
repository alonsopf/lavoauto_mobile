import 'package:json_annotation/json_annotation.dart';

part 'login_respose_modal.g.dart';

@JsonSerializable()
class LoginResponse {
  /// Login status message
  final String? message;

  /// User authentication token
  final String? token;

  LoginResponse({
     this.message,
     this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}