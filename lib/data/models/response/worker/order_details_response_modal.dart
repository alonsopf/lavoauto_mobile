import 'package:json_annotation/json_annotation.dart';

part 'order_details_response_modal.g.dart';

@JsonSerializable()
class OrderDetailsResponse {
  /// List of order details
  final List<OrderDetail>? orders;

  OrderDetailsResponse({ this.orders});

  factory OrderDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailsResponseToJson(this);
}

@JsonSerializable()
class OrderDetail {
  /// Order ID
  @JsonKey(name: 'orden_id')
  final int ordenId;

  /// Order status
  final String estatus;

  /// Scheduled date (ISO8601 string)
  @JsonKey(name: 'fecha_programada')
  final String fechaProgramada;

  /// Approximate weight in kilograms
  @JsonKey(name: 'peso_aproximado_kg')
  final double? pesoAproximadoKg;

  /// Detergent type
  @JsonKey(name: 'tipo_detergente')
  final String? tipoDetergente;

  /// Drying method
  @JsonKey(name: 'metodo_secado')
  final String? metodoSecado;

  /// Special instructions
  @JsonKey(name: 'instrucciones_especiales')
  final String? instruccionesEspeciales;

  /// Payment method ID
  @JsonKey(name: 'payment_method_id')
  final int? paymentMethodId;

  /// Latitude
  final double? lat;

  /// Longitude
  final double? lon;

  /// Address
  final String? direccion;

  /// Client ID
  @JsonKey(name: 'cliente_id')
  final int clienteId;

  /// Accepted price per kilogram
  @JsonKey(name: 'precio_por_kg')
  final double? precioPorKg;

  OrderDetail({
    required this.ordenId,
    required this.estatus,
    required this.fechaProgramada,
    this.pesoAproximadoKg,
    this.tipoDetergente,
    this.metodoSecado,
    this.instruccionesEspeciales,
    this.paymentMethodId,
    this.lat,
    this.lon,
    this.direccion,
    required this.clienteId,
    this.precioPorKg,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailToJson(this);
}