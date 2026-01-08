// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_response_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationResponse _$LocationResponseFromJson(Map<String, dynamic> json) =>
    LocationResponse(
      allow: (json['allow'] as num).toInt(),
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => LocationResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LocationResponseToJson(LocationResponse instance) =>
    <String, dynamic>{
      'allow': instance.allow,
      'results': instance.results,
    };

LocationResult _$LocationResultFromJson(Map<String, dynamic> json) =>
    LocationResult(
      dAsenta: json['d_asenta'] as String,
      dMnpio: json['d_mnpio'] as String,
      dEstado: json['d_estado'] as String,
    );

Map<String, dynamic> _$LocationResultToJson(LocationResult instance) =>
    <String, dynamic>{
      'd_asenta': instance.dAsenta,
      'd_mnpio': instance.dMnpio,
      'd_estado': instance.dEstado,
    };
