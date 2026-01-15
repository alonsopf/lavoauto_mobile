// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'servicio_precio_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServicioPrecioModel _$ServicioPrecioModelFromJson(Map<String, dynamic> json) =>
    ServicioPrecioModel(
      precioId: (json['precio_id'] as num).toInt(),
      categoriaVehiculo: json['categoria_vehiculo'] as String,
      precio: (json['precio'] as num).toDouble(),
      duracionEstimada: (json['duracion_estimada'] as num).toInt(),
      disponible: json['disponible'] as bool,
    );

Map<String, dynamic> _$ServicioPrecioModelToJson(
        ServicioPrecioModel instance) =>
    <String, dynamic>{
      'precio_id': instance.precioId,
      'categoria_vehiculo': instance.categoriaVehiculo,
      'precio': instance.precio,
      'duracion_estimada': instance.duracionEstimada,
      'disponible': instance.disponible,
    };
