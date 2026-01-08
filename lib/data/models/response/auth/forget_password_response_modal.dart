import 'package:json_annotation/json_annotation.dart';

part 'forget_password_response_modal.g.dart';

@JsonSerializable()
class ForgetPasswordResponse {
  /// Response message
  final String? message;

  ForgetPasswordResponse({ this.message});

  factory ForgetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ForgetPasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ForgetPasswordResponseToJson(this);
}