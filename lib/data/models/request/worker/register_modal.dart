import 'package:json_annotation/json_annotation.dart';

part 'register_modal.g.dart';

@JsonSerializable()
class RegisterLavadorRequest {
  /// Bank CLABE (Mexican bank account number)
  @JsonKey(name: 'CLABE')
  final String clabe;

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

  /// Photo URL - OPTIONAL until image is uploaded
  @JsonKey(name: 'foto_url')
  final String? fotoUrl;

  /// Password hash
  @JsonKey(name: 'password_hash')
  final String passwordHash;

  RegisterLavadorRequest({
    required this.clabe,
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
    this.fotoUrl, // Now optional - URL from upload-photo endpoint
    required this.passwordHash,
  });

  factory RegisterLavadorRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterLavadorRequestFromJson(json);

  /// Custom `toJson` method to include the static `path` and nest the model under `body`
  Map<String, dynamic> toJson() => {
        "path": "/register-lavador", // Static path
        "body": _$RegisterLavadorRequestToJson(this), // Serialize the model under "body"
      };
}