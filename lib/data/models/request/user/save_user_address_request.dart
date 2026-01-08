import 'package:json_annotation/json_annotation.dart';

part 'save_user_address_request.g.dart';

@JsonSerializable()
class SaveUserAddressRequest {
  final String token;
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

  SaveUserAddressRequest({
    required this.token,
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
  });

  factory SaveUserAddressRequest.fromJson(Map<String, dynamic> json) =>
      _$SaveUserAddressRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SaveUserAddressRequestToJson(this);
}
