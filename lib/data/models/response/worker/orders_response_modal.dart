import 'package:json_annotation/json_annotation.dart';

part 'orders_response_modal.g.dart';

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
class WorkerOrdersResponse {
  /// List of orders
  final List<WorkerOrder>? orders;

  WorkerOrdersResponse({ this.orders});

  factory WorkerOrdersResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkerOrdersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WorkerOrdersResponseToJson(this);
}

@JsonSerializable()
class WorkerOrder {
  /// Order ID
  @JsonKey(name: 'orden_id')
  final int ordenId;

  /// Order status
  final String estatus;

  /// Scheduled date (ISO8601 string)
  @JsonKey(name: 'fecha_programada')
  final String fechaProgramada;

  /// Approximate weight in kilograms
  @JsonKey(name: 'peso_aproximado_kg', fromJson: _doubleFromJson)
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
  @JsonKey(fromJson: _doubleFromJson)
  final double? lat;

  /// Longitude
  @JsonKey(fromJson: _doubleFromJson)
  final double? lon;

  /// Address
  final String? direccion;

  /// Client ID
  @JsonKey(name: 'cliente_id')
  final int clienteId;

  WorkerOrder({
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
  });

  factory WorkerOrder.fromJson(Map<String, dynamic> json) =>
      _$WorkerOrderFromJson(json);

  Map<String, dynamic> toJson() => _$WorkerOrderToJson(this);
}