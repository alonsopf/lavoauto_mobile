import 'package:json_annotation/json_annotation.dart';

part 'create_bid_modal.g.dart';

@JsonSerializable()
class CreateBidRequest {
  /// User authentication token
  final String token;

  /// Order ID
  @JsonKey(name: 'orden_id')
  final int ordenId;

  /// Price per kilogram
  @JsonKey(name: 'precio_por_kg')
  final double precioPorKg;

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

  CreateBidRequest({
    required this.token,
    required this.ordenId,
    required this.precioPorKg,
    required this.nota,
    this.fechaRecogida,
    this.fechaEstimada,
    this.fechaRecogidaPropuesta,
    this.fechaEntregaPropuesta,
  });

  factory CreateBidRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateBidRequestFromJson(json);

  Map<String, dynamic> toJson() => {
    "path": "/create-puja-lavador", // Static path
    "body": _$CreateBidRequestToJson(this), // Serialize the model under "body"
  };
}