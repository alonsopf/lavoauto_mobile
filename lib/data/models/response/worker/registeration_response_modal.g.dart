// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registeration_response_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkerRegistrationResponse _$WorkerRegistrationResponseFromJson(
        Map<String, dynamic> json) =>
    WorkerRegistrationResponse(
      message: json['message'] as String,
      lavadorId: (json['lavador_id'] as num).toInt(),
    );

Map<String, dynamic> _$WorkerRegistrationResponseToJson(
        WorkerRegistrationResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'lavador_id': instance.lavadorId,
    };
