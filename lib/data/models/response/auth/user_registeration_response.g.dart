// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_registeration_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRegistrationResponse _$UserRegistrationResponseFromJson(
        Map<String, dynamic> json) =>
    UserRegistrationResponse(
      message: json['message'] as String?,
      clienteId: (json['cliente_id'] as num?)?.toInt(),
      lavadorId: (json['lavador_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserRegistrationResponseToJson(
        UserRegistrationResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'cliente_id': instance.clienteId,
      'lavador_id': instance.lavadorId,
    };
