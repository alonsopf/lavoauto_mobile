import 'package:json_annotation/json_annotation.dart';

part 'user_worker_info_modal.g.dart';

@JsonSerializable()
class UserWorkerInfoResponse {
  /// User type (e.g., "lavador")
  @JsonKey(name: 'user_type')
  final String? userType;

  /// Worker information (nested under "data")
  final UserWorkerInfo? data;

  UserWorkerInfoResponse({
    this.userType,
    this.data,
  });

  factory UserWorkerInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$UserWorkerInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserWorkerInfoResponseToJson(this);
}

@JsonSerializable()
class UserWorkerInfo {
  /// First name
  final String? nombre;

  /// Last names (surname)
  final String? apellidos;

  /// RFC (Mexican tax ID)
  final String? rfc;

  /// Bank CLABE (Mexican bank account number)
  final String? clabe;

  /// Email address
  final String? email;

  /// Street name
  final String? calle;

  /// Exterior number
  final String? numeroexterior;

  /// Interior number
  final String? numerointerior;

  /// Neighborhood/Colony
  final String? colonia;

  /// City
  final String? ciudad;

  /// State
  final String? estado;

  /// Postal code
  @JsonKey(name: 'codigo_postal')
  final String? codigoPostal;

  /// Latitude
  final double? lat;

  /// Longitude
  final double? lon;

  /// Worker rating (stars)
  final double? stars;

  /// Photo URL
  @JsonKey(name: 'foto_url')
  final String? fotoUrl;

  /// Stripe account ID
  @JsonKey(name: 'stripe_account_id')
  final String? stripeAccountId;

  /// Stripe account status
  @JsonKey(name: 'stripe_account_status')
  final String? stripeAccountStatus;

  /// Password hash (optional, usually empty)
  @JsonKey(name: 'password_hash')
  final String? passwordHash;

  /// Price per kilometer
  @JsonKey(name: 'precio_km')
  final double? precioKm;

  UserWorkerInfo({
    this.nombre,
    this.apellidos,
    this.rfc,
    this.clabe,
    this.email,
    this.calle,
    this.numeroexterior,
    this.numerointerior,
    this.colonia,
    this.ciudad,
    this.estado,
    this.codigoPostal,
    this.lat,
    this.lon,
    this.stars,
    this.fotoUrl,
    this.stripeAccountId,
    this.stripeAccountStatus,
    this.passwordHash,
    this.precioKm,
  });

  factory UserWorkerInfo.fromJson(Map<String, dynamic> json) =>
      _$UserWorkerInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserWorkerInfoToJson(this);
}