// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_user_address_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveUserAddressRequest _$SaveUserAddressRequestFromJson(
        Map<String, dynamic> json) =>
    SaveUserAddressRequest(
      token: json['token'] as String,
      tipo: json['tipo'] as String,
      etiqueta: json['etiqueta'] as String?,
      calle: json['calle'] as String,
      numero_exterior: json['numero_exterior'] as String?,
      numero_interior: json['numero_interior'] as String?,
      colonia: json['colonia'] as String?,
      ciudad: json['ciudad'] as String?,
      estado: json['estado'] as String?,
      codigo_postal: json['codigo_postal'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      es_predeterminada: json['es_predeterminada'] as bool,
      descripcion_adicional: json['descripcion_adicional'] as String?,
    );

Map<String, dynamic> _$SaveUserAddressRequestToJson(
        SaveUserAddressRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
      'tipo': instance.tipo,
      'etiqueta': instance.etiqueta,
      'calle': instance.calle,
      'numero_exterior': instance.numero_exterior,
      'numero_interior': instance.numero_interior,
      'colonia': instance.colonia,
      'ciudad': instance.ciudad,
      'estado': instance.estado,
      'codigo_postal': instance.codigo_postal,
      'lat': instance.lat,
      'lon': instance.lon,
      'es_predeterminada': instance.es_predeterminada,
      'descripcion_adicional': instance.descripcion_adicional,
    };
