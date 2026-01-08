import 'package:json_annotation/json_annotation.dart';

part 'orders_response_modal.g.dart';

@JsonSerializable()
class UserOrdersResponse {
  /// List of user orders
  final List<UserOrder>? orders;

  UserOrdersResponse({ this.orders});

  factory UserOrdersResponse.fromJson(Map<String, dynamic> json) =>
      _$UserOrdersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserOrdersResponseToJson(this);
}

@JsonSerializable()
class UserOrder {
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

  /// Fabric softener
  @JsonKey(name: 'suavizante')
  final bool? suavizante;

  /// Drying method
  @JsonKey(name: 'metodo_secado')
  final String? metodoSecado;

  /// Ironing type: 'con_gancho', 'sin_gancho', or null
  @JsonKey(name: 'tipo_planchado')
  final String? tipoPlanchado;

  /// Number of garments to iron
  @JsonKey(name: 'numero_prendas_planchado')
  final int? numeroPrendasPlanchado;

  /// Special instructions
  @JsonKey(name: 'instrucciones_especiales')
  final String? instruccionesEspeciales;

  /// Payment method ID
  @JsonKey(name: 'payment_method_id')
  final int? paymentMethodId;

  /// Payment card last 4 digits (masked format: **** **** **** 1234)
  @JsonKey(name: 'payment_card_last4')
  final String? paymentCardLast4;

  /// Payment card type (e.g., "tarjeta")
  @JsonKey(name: 'payment_card_type')
  final String? paymentCardType;

  /// Latitude
  final double? lat;

  /// Longitude
  final double? lon;

  /// Address
  final String? direccion;

  /// Lavador ID (service provider assigned to this order)
  @JsonKey(name: 'lavador_id')
  final int? lavadorId;

  /// Lavador photo URL
  @JsonKey(name: 'lavador_foto_url')
  final String? lavadorFotoUrl;

  /// Client's proposed pickup time
  @JsonKey(name: 'fecha_recogida_propuesta_cliente')
  final String? fechaRecogidaPropuestaCliente;

  /// Client's proposed delivery time
  @JsonKey(name: 'fecha_entrega_propuesta_cliente')
  final String? fechaEntregaPropuestaCliente;

  /// Worker's proposed pickup time
  @JsonKey(name: 'fecha_recogida_propuesta_lavador')
  final String? fechaRecogidaPropuestaLavador;

  /// Worker's proposed delivery time
  @JsonKey(name: 'fecha_entrega_propuesta_lavador')
  final String? fechaEntregaPropuestaLavador;

  /// Express washing
  @JsonKey(name: 'lavado_urgente')
  final bool? lavadoUrgente;

  /// Express washing + drying
  @JsonKey(name: 'lavado_secado_urgente')
  final bool? lavadoSecadoUrgente;

  /// Express washing + drying + ironing
  @JsonKey(name: 'lavado_secado_planchado_urgente')
  final bool? lavadoSecadoPlanchadoUrgente;

  UserOrder({
    required this.ordenId,
    required this.estatus,
    required this.fechaProgramada,
    this.pesoAproximadoKg,
    this.tipoDetergente,
    this.suavizante,
    this.metodoSecado,
    this.tipoPlanchado,
    this.numeroPrendasPlanchado,
    this.instruccionesEspeciales,
    this.paymentMethodId,
    this.paymentCardLast4,
    this.paymentCardType,
    this.lat,
    this.lon,
    this.direccion,
    this.lavadorId,
    this.lavadorFotoUrl,
    this.fechaRecogidaPropuestaCliente,
    this.fechaEntregaPropuestaCliente,
    this.fechaRecogidaPropuestaLavador,
    this.fechaEntregaPropuestaLavador,
    this.lavadoUrgente,
    this.lavadoSecadoUrgente,
    this.lavadoSecadoPlanchadoUrgente,
  });

  factory UserOrder.fromJson(Map<String, dynamic> json) =>
      _$UserOrderFromJson(json);

  Map<String, dynamic> toJson() => _$UserOrderToJson(this);
}