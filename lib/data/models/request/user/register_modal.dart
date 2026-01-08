import 'package:json_annotation/json_annotation.dart';

part 'register_modal.g.dart';

@JsonSerializable()
class RegisterRequest {
  /// First name
  final String nombre;

  /// Last names (surname)
  final String apellidos;

  /// RFC (Mexican tax ID)
  final String rfc;

  /// Email address
  final String email;

  /// Street name
  final String calle;

  /// Exterior number
  final String numeroexterior;

  /// Interior number - OPTIONAL
  final String? numerointerior;

  /// Neighborhood/Colony
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

  /// Photo URL - OPTIONAL for users
  @JsonKey(name: 'foto_url')
  final String? fotoUrl;

  /// Password hash
  @JsonKey(name: 'password_hash')
  final String passwordHash;

  RegisterRequest({
    required this.nombre,
    required this.apellidos,
    required this.rfc,
    required this.email,
    required this.calle,
    required this.numeroexterior,
    this.numerointerior, // Now optional
    required this.colonia,
    required this.ciudad,
    required this.estado,
    required this.codigoPostal,
    required this.lat,
    required this.lon,
    required this.telefono,
    this.fotoUrl, // Now optional
    required this.passwordHash,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  /// Custom `toJson` method to include the static `path` and nest the model under `body`
  Map<String, dynamic> toJson() => {
        "path": "/register", // Static path
        "body": _$RegisterRequestToJson(this), // Serialize the model under "body"
      };
}