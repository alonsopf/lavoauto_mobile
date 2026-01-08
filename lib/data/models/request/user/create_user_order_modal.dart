import 'package:json_annotation/json_annotation.dart';

part 'create_user_order_modal.g.dart';

@JsonSerializable()
class CreateUserOrderRequest {
  /// User authentication token
  final String token;

  /// Scheduled date (ISO8601 string)
  @JsonKey(name: 'fecha_programada')
  final String fechaProgramada;

  /// Approximate weight in kilograms
  @JsonKey(name: 'peso_aproximado_kg')
  final double pesoAproximadoKg;

  /// Detergent type: 'En polvo', 'Líquido', 'Blanqueador', 'Desengrasante'
  @JsonKey(name: 'tipo_detergente')
  final String tipoDetergente;

  /// Fabric softener/conditioner: true or false
  @JsonKey(name: 'suavizante')
  final bool suavizante;

  /// Drying method
  @JsonKey(name: 'metodo_secado')
  final String metodoSecado;

  /// Ironing type: 'con_gancho', 'sin_gancho', or null
  @JsonKey(name: 'tipo_planchado')
  final String? tipoPlanchado;

  /// Number of garments to iron (0 if no ironing)
  @JsonKey(name: 'numero_prendas_planchado')
  final int numeroPrendasPlanchado;

  /// Special instructions
  @JsonKey(name: 'instrucciones_especiales')
  final String instruccionesEspeciales;

  /// Payment method ID
  @JsonKey(name: 'payment_method_id')
  final String paymentMethodId;

  /// Latitude coordinate
  @JsonKey(name: 'lat')
  final double lat;

  /// Longitude coordinate
  @JsonKey(name: 'lon')
  final double lon;

  /// Full address
  @JsonKey(name: 'direccion')
  final String direccion;

  /// Client's proposed pickup time (ISO8601 string)
  @JsonKey(name: 'fecha_recogida_propuesta_cliente')
  final String? fechaRecogidaPropuestaCliente;

  /// Client's proposed delivery time (ISO8601 string)
  @JsonKey(name: 'fecha_entrega_propuesta_cliente')
  final String? fechaEntregaPropuestaCliente;

  /// Express washing
  @JsonKey(name: 'lavado_urgente')
  final bool lavadoUrgente;

  /// Express washing + drying
  @JsonKey(name: 'lavado_secado_urgente')
  final bool lavadoSecadoUrgente;

  /// Express washing + drying + ironing
  @JsonKey(name: 'lavado_secado_planchado_urgente')
  final bool lavadoSecadoPlanchadoUrgente;

  CreateUserOrderRequest({
    required this.token,
    required this.fechaProgramada,
    required this.pesoAproximadoKg,
    required this.tipoDetergente,
    required this.suavizante,
    required this.metodoSecado,
    this.tipoPlanchado,
    this.numeroPrendasPlanchado = 0,
    required this.instruccionesEspeciales,
    required this.paymentMethodId,
    required this.lat,
    required this.lon,
    required this.direccion,
    this.fechaRecogidaPropuestaCliente,
    this.fechaEntregaPropuestaCliente,
    this.lavadoUrgente = false,
    this.lavadoSecadoUrgente = false,
    this.lavadoSecadoPlanchadoUrgente = false,
  });

  factory CreateUserOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateUserOrderRequestFromJson(json);

  /// Custom `toJson` method to include the static `path` and nest the model under `body`
  Map<String, dynamic> toJson() => {
        "path": "/create-order", // Static path
        "body": _$CreateUserOrderRequestToJson(
            this), // Serialize the model under "body"
      };
}
