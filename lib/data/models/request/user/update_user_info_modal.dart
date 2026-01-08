import 'package:json_annotation/json_annotation.dart';

part 'update_user_info_modal.g.dart';

@JsonSerializable()
class UpdateUserInfoRequest {
  /// User authentication token
  final String token;

  /// User update data
  @JsonKey(name: 'body')
  final UpdateUserInfoBody body;

  UpdateUserInfoRequest({
    required this.token,
    required this.body,
  });

  factory UpdateUserInfoRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserInfoRequestFromJson(json);

  /// Custom `toJson` method to include the static `path` and nest the model under `body`
  Map<String, dynamic> toJson() => {
        "path": "/update-info", // Static path
        "body": _$UpdateUserInfoRequestToJson(this), // Serialize the model under "body"
      };
}

@JsonSerializable()
class UpdateUserInfoBody {
  /// User first name
  final String nombre;

  /// User last name
  final String apellidos;

  /// User RFC (tax ID)
  final String rfc;

  /// Street address
  final String calle;

  /// Exterior number
  @JsonKey(name: 'numeroexterior')
  final String numeroExterior;

  /// Interior number
  @JsonKey(name: 'numerointerior')
  final String numeroInterior;

  /// Neighborhood
  final String colonia;

  /// City
  final String ciudad;

  /// State
  final String estado;

  /// Postal code
  @JsonKey(name: 'codigo_postal')
  final String codigoPostal;

  /// Latitude
  final double lat;

  /// Longitude
  final double lon;

  /// Phone number
  final String telefono;

  /// Profile photo URL - Optional for updates
  @JsonKey(name: 'foto_url')
  final String? fotoURL;

  UpdateUserInfoBody({
    required this.nombre,
    required this.apellidos,
    required this.rfc,
    required this.calle,
    required this.numeroExterior,
    required this.numeroInterior,
    required this.colonia,
    required this.ciudad,
    required this.estado,
    required this.codigoPostal,
    required this.lat,
    required this.lon,
    required this.telefono,
    this.fotoURL, // Now optional for updates
  });

  factory UpdateUserInfoBody.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserInfoBodyFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserInfoBodyToJson(this);
} 