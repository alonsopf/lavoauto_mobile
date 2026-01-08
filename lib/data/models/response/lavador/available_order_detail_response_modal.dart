import 'package:json_annotation/json_annotation.dart';

part 'available_order_detail_response_modal.g.dart';

@JsonSerializable()
class AvailableOrderDetailResponse {
  /// Order ID
  @JsonKey(name: 'orden_id')
  final int ordenId;

  /// Order status
  @JsonKey(name: 'estatus')
  final String estatus;

  /// Scheduled date
  @JsonKey(name: 'fecha_programada')
  final String fechaProgramada;

  /// Approximate weight in kg
  @JsonKey(name: 'peso_aproximado_kg')
  final double pesoAproximadoKg;

  /// Detergent type
  @JsonKey(name: 'tipo_detergente')
  final String tipoDetergente;

  /// Drying method
  @JsonKey(name: 'metodo_secado')
  final String metodoSecado;

  /// Special instructions
  @JsonKey(name: 'instrucciones_especiales')
  final String instruccionesEspeciales;

  /// Payment method ID
  @JsonKey(name: 'payment_method_id')
  final int paymentMethodId;

  /// Latitude
  @JsonKey(name: 'lat')
  final double lat;

  /// Longitude
  @JsonKey(name: 'lon')
  final double lon;

  /// Address
  @JsonKey(name: 'direccion')
  final String direccion;

  /// Client ID
  @JsonKey(name: 'cliente_id')
  final int clienteId;

  /// Order creation date
  @JsonKey(name: 'fecha_creacion')
  final String fechaCreacion;

  /// Price per kg (optional)
  @JsonKey(name: 'precio_por_kg')
  final double? precioPorKg;

  /// Tip amount (optional)
  @JsonKey(name: 'propina')
  final double? propina;

  /// Final weight in kg (optional)
  @JsonKey(name: 'peso_final_kg')
  final double? pesoFinalKg;

  /// Completion date (optional)
  @JsonKey(name: 'fecha_completada')
  final String? fechaCompletada;

  AvailableOrderDetailResponse({
    required this.ordenId,
    required this.estatus,
    required this.fechaProgramada,
    required this.pesoAproximadoKg,
    required this.tipoDetergente,
    required this.metodoSecado,
    required this.instruccionesEspeciales,
    required this.paymentMethodId,
    required this.lat,
    required this.lon,
    required this.direccion,
    required this.clienteId,
    required this.fechaCreacion,
    this.precioPorKg,
    this.propina,
    this.pesoFinalKg,
    this.fechaCompletada,
  });

  factory AvailableOrderDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$AvailableOrderDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AvailableOrderDetailResponseToJson(this);
}