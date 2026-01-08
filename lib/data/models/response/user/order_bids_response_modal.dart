import 'package:json_annotation/json_annotation.dart';

part 'order_bids_response_modal.g.dart';

/// Helper function to safely convert dynamic values to double
double? _doubleFromJson(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    if (value.isEmpty || value.toLowerCase() == 'null') return null;
    return double.tryParse(value);
  }
  if (value is num) return value.toDouble();
  return null;
}

@JsonSerializable()
class OrderBidsResponse {
  /// List of bids for the order
  final List<OrderBid>? pujas;

  OrderBidsResponse({this.pujas});

  factory OrderBidsResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderBidsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderBidsResponseToJson(this);
}

@JsonSerializable()
class OrderBid {
  /// Bid ID
  @JsonKey(name: 'puja_id')
  final int pujaId;

  /// Lavador (worker) ID
  @JsonKey(name: 'lavador_id')
  final int lavadorId;

  /// Lavador name
  @JsonKey(name: 'lavador_nombre')
  final String? lavadorNombre;

  /// Lavador profile photo URL
  @JsonKey(name: 'lavador_foto_url')
  final String? lavadorFotoUrl;

  /// Lavador rating (average)
  @JsonKey(name: 'lavador_rating', fromJson: _doubleFromJson)
  final double? lavadorRating;

  /// Price per kilogram
  @JsonKey(name: 'precio_por_kg', fromJson: _doubleFromJson)
  final double? precioPorKg;

  /// Note or message
  final String nota;

  /// Pickup date (ISO8601 string) - Legacy field
  @JsonKey(name: 'fecha_recogida')
  final String? fechaRecogida;

  /// Estimated delivery date (ISO8601 string) - Legacy field
  @JsonKey(name: 'fecha_estimada')
  final String? fechaEstimada;

  /// Worker's proposed pickup time (ISO8601 string)
  @JsonKey(name: 'fecha_recogida_propuesta')
  final String? fechaRecogidaPropuesta;

  /// Worker's proposed delivery time (ISO8601 string)
  @JsonKey(name: 'fecha_entrega_propuesta')
  final String? fechaEntregaPropuesta;

  /// Bid status
  final String status;

  /// Bid creation date (ISO8601 string)
  @JsonKey(name: 'fecha_creacion')
  final String fechaCreacion;

  OrderBid({
    required this.pujaId,
    required this.lavadorId,
    this.lavadorNombre,
    this.lavadorFotoUrl,
    this.lavadorRating,
    this.precioPorKg,
    required this.nota,
    this.fechaRecogida,
    this.fechaEstimada,
    this.fechaRecogidaPropuesta,
    this.fechaEntregaPropuesta,
    required this.status,
    required this.fechaCreacion,
  });

  factory OrderBid.fromJson(Map<String, dynamic> json) =>
      _$OrderBidFromJson(json);

  Map<String, dynamic> toJson() => _$OrderBidToJson(this);
}
