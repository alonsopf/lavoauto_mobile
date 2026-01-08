// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_worker_info_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateWorkerInfoRequest _$UpdateWorkerInfoRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkerInfoRequest(
      token: json['token'] as String,
      body: UpdateWorkerInfoBody.fromJson(json['body'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateWorkerInfoRequestToJson(
        UpdateWorkerInfoRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
      'body': instance.body,
    };

UpdateWorkerInfoBody _$UpdateWorkerInfoBodyFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkerInfoBody(
      nombre: json['nombre'] as String,
      apellidos: json['apellidos'] as String,
      rfc: json['rfc'] as String,
      clabe: json['clabe'] as String,
      calle: json['calle'] as String,
      numeroExterior: json['numeroexterior'] as String,
      numeroInterior: json['numerointerior'] as String,
      colonia: json['colonia'] as String,
      ciudad: json['ciudad'] as String,
      estado: json['estado'] as String,
      codigoPostal: json['codigo_postal'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      fotoURL: json['foto_url'] as String?,
    );

Map<String, dynamic> _$UpdateWorkerInfoBodyToJson(
        UpdateWorkerInfoBody instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'apellidos': instance.apellidos,
      'rfc': instance.rfc,
      'clabe': instance.clabe,
      'calle': instance.calle,
      'numeroexterior': instance.numeroExterior,
      'numerointerior': instance.numeroInterior,
      'colonia': instance.colonia,
      'ciudad': instance.ciudad,
      'estado': instance.estado,
      'codigo_postal': instance.codigoPostal,
      'lat': instance.lat,
      'lon': instance.lon,
      'foto_url': instance.fotoURL,
    };
