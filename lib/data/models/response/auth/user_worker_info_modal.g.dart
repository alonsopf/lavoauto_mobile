// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_worker_info_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserWorkerInfoResponse _$UserWorkerInfoResponseFromJson(
        Map<String, dynamic> json) =>
    UserWorkerInfoResponse(
      userType: json['user_type'] as String?,
      data: json['data'] == null
          ? null
          : UserWorkerInfo.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserWorkerInfoResponseToJson(
        UserWorkerInfoResponse instance) =>
    <String, dynamic>{
      'user_type': instance.userType,
      'data': instance.data,
    };

UserWorkerInfo _$UserWorkerInfoFromJson(Map<String, dynamic> json) =>
    UserWorkerInfo(
      nombre: json['nombre'] as String?,
      apellidos: json['apellidos'] as String?,
      rfc: json['rfc'] as String?,
      clabe: json['clabe'] as String?,
      email: json['email'] as String?,
      calle: json['calle'] as String?,
      numeroexterior: json['numeroexterior'] as String?,
      numerointerior: json['numerointerior'] as String?,
      colonia: json['colonia'] as String?,
      ciudad: json['ciudad'] as String?,
      estado: json['estado'] as String?,
      codigoPostal: json['codigo_postal'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      stars: (json['stars'] as num?)?.toDouble(),
      fotoUrl: json['foto_url'] as String?,
      stripeAccountId: json['stripe_account_id'] as String?,
      stripeAccountStatus: json['stripe_account_status'] as String?,
      passwordHash: json['password_hash'] as String?,
      precioKm: (json['precio_km'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$UserWorkerInfoToJson(UserWorkerInfo instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'apellidos': instance.apellidos,
      'rfc': instance.rfc,
      'clabe': instance.clabe,
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
      'stars': instance.stars,
      'foto_url': instance.fotoUrl,
      'stripe_account_id': instance.stripeAccountId,
      'stripe_account_status': instance.stripeAccountStatus,
      'password_hash': instance.passwordHash,
      'precio_km': instance.precioKm,
    };
