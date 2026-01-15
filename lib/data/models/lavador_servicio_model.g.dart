// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lavador_servicio_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LavadorServicioModel _$LavadorServicioModelFromJson(
        Map<String, dynamic> json) =>
    LavadorServicioModel(
      tipoServicioId: (json['tipo_servicio_id'] as num).toInt(),
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      precios: (json['precios'] as List<dynamic>)
          .map((e) => ServicioPrecioModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LavadorServicioModelToJson(
        LavadorServicioModel instance) =>
    <String, dynamic>{
      'tipo_servicio_id': instance.tipoServicioId,
      'nombre': instance.nombre,
      'descripcion': instance.descripcion,
      'precios': instance.precios,
    };
