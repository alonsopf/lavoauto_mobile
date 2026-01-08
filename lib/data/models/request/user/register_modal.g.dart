// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      nombre: json['nombre'] as String,
      apellidos: json['apellidos'] as String,
      rfc: json['rfc'] as String,
      email: json['email'] as String,
      calle: json['calle'] as String,
      numeroexterior: json['numeroexterior'] as String,
      numerointerior: json['numerointerior'] as String?,
      colonia: json['colonia'] as String,
      ciudad: json['ciudad'] as String,
      estado: json['estado'] as String,
      codigoPostal: json['codigo_postal'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      telefono: json['telefono'] as String,
      fotoUrl: json['foto_url'] as String?,
      passwordHash: json['password_hash'] as String,
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'apellidos': instance.apellidos,
      'rfc': instance.rfc,
      'email': instance.email,
      'calle': instance.calle,
      'numeroexterior': instance.numeroexterior,
      'numerointerior': instance.numerointerior,
      'colonia': instance.colonia,
      'ciudad': instance.ciudad,
      'estado': instance.estado,
      'codigo_postal': instance.codigoPostal,
      'lat': instance.lat,
      'lon': instance.lon,
      'telefono': instance.telefono,
      'foto_url': instance.fotoUrl,
      'password_hash': instance.passwordHash,
    };
