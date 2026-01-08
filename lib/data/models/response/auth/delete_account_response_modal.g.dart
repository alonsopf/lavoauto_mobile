// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_account_response_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteAccountResponse _$DeleteAccountResponseFromJson(
        Map<String, dynamic> json) =>
    DeleteAccountResponse(
      message: json['message'] as String?,
      deletedUser: json['deleted_user'] as String?,
    );

Map<String, dynamic> _$DeleteAccountResponseToJson(
        DeleteAccountResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'deleted_user': instance.deletedUser,
    };
