// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_info_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateUserInfoRequest _$UpdateUserInfoRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateUserInfoRequest(
      token: json['token'] as String,
      body: UpdateUserInfoBody.fromJson(json['body'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateUserInfoRequestToJson(
        UpdateUserInfoRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
      'body': instance.body,
    };

UpdateUserInfoBody _$UpdateUserInfoBodyFromJson(Map<String, dynamic> json) =>
    UpdateUserInfoBody(
      nombre: json['nombre'] as String,
      apellidos: json['apellidos'] as String,
      rfc: json['rfc'] as String,
      calle: json['calle'] as String,
      numeroExterior: json['numeroexterior'] as String,
      numeroInterior: json['numerointerior'] as String,
      colonia: json['colonia'] as String,
      ciudad: json['ciudad'] as String,
      estado: json['estado'] as String,
      codigoPostal: json['codigo_postal'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      telefono: json['telefono'] as String,
      fotoURL: json['foto_url'] as String?,
    );

Map<String, dynamic> _$UpdateUserInfoBodyToJson(UpdateUserInfoBody instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'apellidos': instance.apellidos,
      'rfc': instance.rfc,
      'calle': instance.calle,
      'numeroexterior': instance.numeroExterior,
      'numerointerior': instance.numeroInterior,
      'colonia': instance.colonia,
      'ciudad': instance.ciudad,
      'estado': instance.estado,
      'codigo_postal': instance.codigoPostal,
      'lat': instance.lat,
      'lon': instance.lon,
      'telefono': instance.telefono,
      'foto_url': instance.fotoURL,
    };
