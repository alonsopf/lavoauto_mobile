// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lavador_cercano_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LavadorCercano _$LavadorCercanoFromJson(Map<String, dynamic> json) =>
    LavadorCercano(
      lavadorId: (json['lavador_id'] as num).toInt(),
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      telefono: json['telefono'] as String?,
      email: json['email'] as String?,
      direccion: json['direccion'] as String?,
      precioKm: (json['precio_km'] as num).toDouble(),
      calificacionPromedio: (json['calificacion_promedio'] as num).toDouble(),
      distanciaMetros: (json['distancia_metros'] as num).toInt(),
      distanciaKm: (json['distancia_km'] as num).toDouble(),
      duracionSegundos: (json['duracion_segundos'] as num).toInt(),
    );

Map<String, dynamic> _$LavadorCercanoToJson(LavadorCercano instance) =>
    <String, dynamic>{
      'lavador_id': instance.lavadorId,
      'nombre': instance.nombre,
      'apellido': instance.apellido,
      'telefono': instance.telefono,
      'email': instance.email,
      'direccion': instance.direccion,
      'precio_km': instance.precioKm,
      'calificacion_promedio': instance.calificacionPromedio,
      'distancia_metros': instance.distanciaMetros,
      'distancia_km': instance.distanciaKm,
      'duracion_segundos': instance.duracionSegundos,
    };

LavadoresCercanosResponse _$LavadoresCercanosResponseFromJson(
        Map<String, dynamic> json) =>
    LavadoresCercanosResponse(
      lavadores: (json['lavadores'] as List<dynamic>)
          .map((e) => LavadorCercano.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LavadoresCercanosResponseToJson(
        LavadoresCercanosResponse instance) =>
    <String, dynamic>{
      'lavadores': instance.lavadores,
    };
