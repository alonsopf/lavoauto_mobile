import 'package:json_annotation/json_annotation.dart';

part 'user_address_response.g.dart';

@JsonSerializable()
class UserAddress {
  final int id;
  final int cliente_id;
  final String tipo;
  final String? etiqueta;
  final String calle;
  final String? numero_exterior;
  final String? numero_interior;
  final String? colonia;
  final String? ciudad;
  final String? estado;
  final String? codigo_postal;
  final double? lat;
  final double? lon;
  final bool es_predeterminada;
  final String? descripcion_adicional;
  final String? created_at;
  final String? updated_at;

  UserAddress({
    required this.id,
    required this.cliente_id,
    required this.tipo,
    this.etiqueta,
    required this.calle,
    this.numero_exterior,
    this.numero_interior,
    this.colonia,
    this.ciudad,
    this.estado,
    this.codigo_postal,
    this.lat,
    this.lon,
    required this.es_predeterminada,
    this.descripcion_adicional,
    this.created_at,
    this.updated_at,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) =>
      _$UserAddressFromJson(json);

  Map<String, dynamic> toJson() => _$UserAddressToJson(this);
}

@JsonSerializable()
class GetUserAddressesResponse {
  final bool success;
  final List<UserAddress> addresses;
  final int count;

  GetUserAddressesResponse({
    required this.success,
    required this.addresses,
    required this.count,
  });

  factory GetUserAddressesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUserAddressesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetUserAddressesResponseToJson(this);
}

@JsonSerializable()
class SaveUserAddressResponse {
  final bool success;
  final String message;
  final int address_id;
  final UserAddress address;

  SaveUserAddressResponse({
    required this.success,
    required this.message,
    required this.address_id,
    required this.address,
  });

  factory SaveUserAddressResponse.fromJson(Map<String, dynamic> json) =>
      _$SaveUserAddressResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SaveUserAddressResponseToJson(this);
}
