// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_account_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteAccountRequest _$DeleteAccountRequestFromJson(
        Map<String, dynamic> json) =>
    DeleteAccountRequest(
      token: json['token'] as String,
    );

Map<String, dynamic> _$DeleteAccountRequestToJson(
        DeleteAccountRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
    };

DeleteAccountBody _$DeleteAccountBodyFromJson(Map<String, dynamic> json) =>
    DeleteAccountBody(
      token: json['token'] as String,
    );

Map<String, dynamic> _$DeleteAccountBodyToJson(DeleteAccountBody instance) =>
    <String, dynamic>{
      'token': instance.token,
    };
