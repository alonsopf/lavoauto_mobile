import 'package:json_annotation/json_annotation.dart';

part 'update_worker_info_modal.g.dart';

@JsonSerializable()
class UpdateWorkerInfoRequest {
  /// Worker authentication token
  final String token;

  /// Worker update data
  @JsonKey(name: 'body')
  final UpdateWorkerInfoBody body;

  UpdateWorkerInfoRequest({
    required this.token,
    required this.body,
  });

  factory UpdateWorkerInfoRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateWorkerInfoRequestFromJson(json);

  /// Custom `toJson` method to include the static `path` and nest the model under `body`
  Map<String, dynamic> toJson() => {
        "path": "/update-info-lavador", // Static path
        "body": _$UpdateWorkerInfoRequestToJson(this), // Serialize the model under "body"
      };
}

@JsonSerializable()
class UpdateWorkerInfoBody {
  /// Worker first name
  final String nombre;

  /// Worker last name
  final String apellidos;

  /// Worker RFC (tax ID)
  final String rfc;

  /// CLABE (bank account number)
  final String clabe;

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

  /// Profile photo URL - Optional for updates
  @JsonKey(name: 'foto_url')
  final String? fotoURL;

  UpdateWorkerInfoBody({
    required this.nombre,
    required this.apellidos,
    required this.rfc,
    required this.clabe,
    required this.calle,
    required this.numeroExterior,
    required this.numeroInterior,
    required this.colonia,
    required this.ciudad,
    required this.estado,
    required this.codigoPostal,
    required this.lat,
    required this.lon,
    this.fotoURL, // Now optional for updates
  });

  factory UpdateWorkerInfoBody.fromJson(Map<String, dynamic> json) =>
      _$UpdateWorkerInfoBodyFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateWorkerInfoBodyToJson(this);
} 