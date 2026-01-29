// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lavador_cercano_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServicioPrecio _$ServicioPrecioFromJson(Map<String, dynamic> json) =>
    ServicioPrecio(
      precioId: (json['precio_id'] as num).toInt(),
      categoriaVehiculo: json['categoria_vehiculo'] as String,
      precio: (json['precio'] as num).toDouble(),
      duracionEstimada: (json['duracion_estimada'] as num).toInt(),
    );

Map<String, dynamic> _$ServicioPrecioToJson(ServicioPrecio instance) =>
    <String, dynamic>{
      'precio_id': instance.precioId,
      'categoria_vehiculo': instance.categoriaVehiculo,
      'precio': instance.precio,
      'duracion_estimada': instance.duracionEstimada,
    };

ServicioLavador _$ServicioLavadorFromJson(Map<String, dynamic> json) =>
    ServicioLavador(
      tipoServicioId: (json['tipo_servicio_id'] as num).toInt(),
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      precios: (json['precios'] as List<dynamic>)
          .map((e) => ServicioPrecio.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ServicioLavadorToJson(ServicioLavador instance) =>
    <String, dynamic>{
      'tipo_servicio_id': instance.tipoServicioId,
      'nombre': instance.nombre,
      'descripcion': instance.descripcion,
      'precios': instance.precios,
    };

LavadorCercano _$LavadorCercanoFromJson(Map<String, dynamic> json) =>
    LavadorCercano(
      lavadorId: (json['lavador_id'] as num).toInt(),
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      telefono: json['telefono'] as String?,
      email: json['email'] as String?,
      direccion: json['direccion'] as String?,
      fotoUrl: json['foto_url'] as String?,
      precioKm: (json['precio_km'] as num).toDouble(),
      calificacionPromedio: (json['calificacion_promedio'] as num).toDouble(),
      distanciaMetros: (json['distancia_metros'] as num).toInt(),
      distanciaKm: (json['distancia_km'] as num).toDouble(),
      duracionSegundos: (json['duracion_segundos'] as num).toInt(),
      servicios: (json['servicios'] as List<dynamic>?)
          ?.map((e) => ServicioLavador.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LavadorCercanoToJson(LavadorCercano instance) =>
    <String, dynamic>{
      'lavador_id': instance.lavadorId,
      'nombre': instance.nombre,
      'apellido': instance.apellido,
      'telefono': instance.telefono,
      'email': instance.email,
      'direccion': instance.direccion,
      'foto_url': instance.fotoUrl,
      'precio_km': instance.precioKm,
      'calificacion_promedio': instance.calificacionPromedio,
      'distancia_metros': instance.distanciaMetros,
      'distancia_km': instance.distanciaKm,
      'duracion_segundos': instance.duracionSegundos,
      'servicios': instance.servicios,
    };

LavadoresCercanosResponse _$LavadoresCercanosResponseFromJson(
        Map<String, dynamic> json) =>
    LavadoresCercanosResponse(
      lavadores: (json['lavadores'] as List<dynamic>)
          .map((e) => LavadorCercano.fromJson(e as Map<String, dynamic>))
          .toList(),
      clienteDireccion: json['cliente_direccion'] as String?,
    );

Map<String, dynamic> _$LavadoresCercanosResponseToJson(
        LavadoresCercanosResponse instance) =>
    <String, dynamic>{
      'lavadores': instance.lavadores,
      'cliente_direccion': instance.clienteDireccion,
    };
