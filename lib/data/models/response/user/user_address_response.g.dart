// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_address_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAddress _$UserAddressFromJson(Map<String, dynamic> json) => UserAddress(
      id: (json['id'] as num).toInt(),
      cliente_id: (json['cliente_id'] as num).toInt(),
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
      created_at: json['created_at'] as String?,
      updated_at: json['updated_at'] as String?,
    );

Map<String, dynamic> _$UserAddressToJson(UserAddress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cliente_id': instance.cliente_id,
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
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };

GetUserAddressesResponse _$GetUserAddressesResponseFromJson(
        Map<String, dynamic> json) =>
    GetUserAddressesResponse(
      success: json['success'] as bool,
      addresses: (json['addresses'] as List<dynamic>)
          .map((e) => UserAddress.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$GetUserAddressesResponseToJson(
        GetUserAddressesResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'addresses': instance.addresses,
      'count': instance.count,
    };

SaveUserAddressResponse _$SaveUserAddressResponseFromJson(
        Map<String, dynamic> json) =>
    SaveUserAddressResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      address_id: (json['address_id'] as num).toInt(),
      address: UserAddress.fromJson(json['address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SaveUserAddressResponseToJson(
        SaveUserAddressResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'address_id': instance.address_id,
      'address': instance.address,
    };
