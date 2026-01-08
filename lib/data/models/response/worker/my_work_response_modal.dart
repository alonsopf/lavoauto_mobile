import 'package:json_annotation/json_annotation.dart';

part 'my_work_response_modal.g.dart';

@JsonSerializable()
class MyWorkResponse {
  /// Lavador (worker) ID
  @JsonKey(name: 'lavador_id')
  final int lavadorId;

  /// Total number of orders
  @JsonKey(name: 'total_orders')
  final int totalOrders;

  /// List of work orders
  @JsonKey(name: 'work_orders')
  final List<MyWorkOrder>? workOrders;

  MyWorkResponse({
    required this.lavadorId,
    required this.totalOrders,
    this.workOrders,
  });

  factory MyWorkResponse.fromJson(Map<String, dynamic> json) =>
      _$MyWorkResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MyWorkResponseToJson(this);
}

@JsonSerializable()
class MyWorkOrder {
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

  /// Client photo URL
  @JsonKey(name: 'cliente_foto_url')
  final String? clienteFotoUrl;

  /// Accepted price per kilogram for this order (if bid accepted)
  @JsonKey(name: 'precio_por_kg')
  final double? precioPorKg;

  /// Final weight in kilograms (after collection)
  @JsonKey(name: 'peso_final_kg')
  final double? pesoFinalKg;

  /// Final cost (peso_final_kg * precio_por_kg)
  @JsonKey(name: 'costo_final')
  final double? costoFinal;

  /// Completion date (ISO8601 string)
  @JsonKey(name: 'fecha_completada')
  final String? fechaCompletada;

  /// Tip amount
  final double? propina;

  /// Creation date (ISO8601 string)
  @JsonKey(name: 'fecha_creacion')
  final String fechaCreacion;

  MyWorkOrder({
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
    this.clienteFotoUrl,
    this.precioPorKg,
    this.pesoFinalKg,
    this.costoFinal,
    this.fechaCompletada,
    this.propina,
    required this.fechaCreacion,
  });

  factory MyWorkOrder.fromJson(Map<String, dynamic> json) =>
      _$MyWorkOrderFromJson(json);

  Map<String, dynamic> toJson() => _$MyWorkOrderToJson(this);
} 