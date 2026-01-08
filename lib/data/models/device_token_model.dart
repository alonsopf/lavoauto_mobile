import 'package:json_annotation/json_annotation.dart';

part 'device_token_model.g.dart';

@JsonSerializable()
class RegisterDeviceTokenRequest {
  @JsonKey(name: 'device_token')
  final String deviceToken;

  @JsonKey(name: 'platform')
  final String platform; // "ios" or "android"

  RegisterDeviceTokenRequest({
    required this.deviceToken,
    required this.platform,
  });

  factory RegisterDeviceTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterDeviceTokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterDeviceTokenRequestToJson(this);
}

@JsonSerializable()
class RegisterDeviceTokenResponse {
  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'token_id')
  final int tokenId;

  @JsonKey(name: 'message')
  final String message;

  RegisterDeviceTokenResponse({
    required this.success,
    required this.tokenId,
    required this.message,
  });

  factory RegisterDeviceTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterDeviceTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterDeviceTokenResponseToJson(this);
}

@JsonSerializable()
class UpdateNotificationSettingsRequest {
  @JsonKey(name: 'notifications_enabled')
  final bool notificationsEnabled;

  UpdateNotificationSettingsRequest({
    required this.notificationsEnabled,
  });

  factory UpdateNotificationSettingsRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateNotificationSettingsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateNotificationSettingsRequestToJson(this);
}

@JsonSerializable()
class UpdateNotificationSettingsResponse {
  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'notifications_enabled')
  final bool notificationsEnabled;

  UpdateNotificationSettingsResponse({
    required this.success,
    required this.notificationsEnabled,
  });

  factory UpdateNotificationSettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateNotificationSettingsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateNotificationSettingsResponseToJson(this);
}
