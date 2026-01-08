// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterDeviceTokenRequest _$RegisterDeviceTokenRequestFromJson(
        Map<String, dynamic> json) =>
    RegisterDeviceTokenRequest(
      deviceToken: json['device_token'] as String,
      platform: json['platform'] as String,
    );

Map<String, dynamic> _$RegisterDeviceTokenRequestToJson(
        RegisterDeviceTokenRequest instance) =>
    <String, dynamic>{
      'device_token': instance.deviceToken,
      'platform': instance.platform,
    };

RegisterDeviceTokenResponse _$RegisterDeviceTokenResponseFromJson(
        Map<String, dynamic> json) =>
    RegisterDeviceTokenResponse(
      success: json['success'] as bool,
      tokenId: (json['token_id'] as num).toInt(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$RegisterDeviceTokenResponseToJson(
        RegisterDeviceTokenResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'token_id': instance.tokenId,
      'message': instance.message,
    };

UpdateNotificationSettingsRequest _$UpdateNotificationSettingsRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateNotificationSettingsRequest(
      notificationsEnabled: json['notifications_enabled'] as bool,
    );

Map<String, dynamic> _$UpdateNotificationSettingsRequestToJson(
        UpdateNotificationSettingsRequest instance) =>
    <String, dynamic>{
      'notifications_enabled': instance.notificationsEnabled,
    };

UpdateNotificationSettingsResponse _$UpdateNotificationSettingsResponseFromJson(
        Map<String, dynamic> json) =>
    UpdateNotificationSettingsResponse(
      success: json['success'] as bool,
      notificationsEnabled: json['notifications_enabled'] as bool,
    );

Map<String, dynamic> _$UpdateNotificationSettingsResponseToJson(
        UpdateNotificationSettingsResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'notifications_enabled': instance.notificationsEnabled,
    };
