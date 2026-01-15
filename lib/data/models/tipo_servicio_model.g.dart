// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tipo_servicio_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TipoServicioModel _$TipoServicioModelFromJson(Map<String, dynamic> json) =>
    TipoServicioModel(
      tipoServicioId: (json['tipo_servicio_id'] as num).toInt(),
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
    );

Map<String, dynamic> _$TipoServicioModelToJson(TipoServicioModel instance) =>
    <String, dynamic>{
      'tipo_servicio_id': instance.tipoServicioId,
      'nombre': instance.nombre,
      'descripcion': instance.descripcion,
    };
