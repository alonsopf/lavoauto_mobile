// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehiculo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehiculoModel _$VehiculoModelFromJson(Map<String, dynamic> json) =>
    VehiculoModel(
      vehiculoId: (json['vehiculo_id'] as num).toInt(),
      marca: json['marca'] as String,
      modelo: json['modelo'] as String,
      anio: (json['anio'] as num?)?.toInt(),
      tipoVehiculo: json['tipo_vehiculo'] as String,
    );

Map<String, dynamic> _$VehiculoModelToJson(VehiculoModel instance) =>
    <String, dynamic>{
      'vehiculo_id': instance.vehiculoId,
      'marca': instance.marca,
      'modelo': instance.modelo,
      'anio': instance.anio,
      'tipo_vehiculo': instance.tipoVehiculo,
    };

ClienteVehiculoModel _$ClienteVehiculoModelFromJson(
        Map<String, dynamic> json) =>
    ClienteVehiculoModel(
      vehiculoClienteId: (json['vehiculo_cliente_id'] as num).toInt(),
      vehiculoId: (json['vehiculo_id'] as num).toInt(),
      marca: json['marca'] as String,
      modelo: json['modelo'] as String,
      anio: (json['anio'] as num?)?.toInt(),
      tipoVehiculo: json['tipo_vehiculo'] as String,
      alias: json['alias'] as String?,
      color: json['color'] as String?,
      placas: json['placas'] as String?,
    );

Map<String, dynamic> _$ClienteVehiculoModelToJson(
        ClienteVehiculoModel instance) =>
    <String, dynamic>{
      'vehiculo_cliente_id': instance.vehiculoClienteId,
      'vehiculo_id': instance.vehiculoId,
      'marca': instance.marca,
      'modelo': instance.modelo,
      'anio': instance.anio,
      'tipo_vehiculo': instance.tipoVehiculo,
      'alias': instance.alias,
      'color': instance.color,
      'placas': instance.placas,
    };

ClienteVehiculosResponse _$ClienteVehiculosResponseFromJson(
        Map<String, dynamic> json) =>
    ClienteVehiculosResponse(
      vehiculos: (json['vehiculos'] as List<dynamic>)
          .map((e) => ClienteVehiculoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ClienteVehiculosResponseToJson(
        ClienteVehiculosResponse instance) =>
    <String, dynamic>{
      'vehiculos': instance.vehiculos,
    };

CatalogoVehiculosResponse _$CatalogoVehiculosResponseFromJson(
        Map<String, dynamic> json) =>
    CatalogoVehiculosResponse(
      vehiculos: (json['vehiculos'] as List<dynamic>)
          .map((e) => VehiculoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CatalogoVehiculosResponseToJson(
        CatalogoVehiculosResponse instance) =>
    <String, dynamic>{
      'vehiculos': instance.vehiculos,
    };
