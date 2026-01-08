import 'package:json_annotation/json_annotation.dart';

part 'create_order_request.g.dart';

@JsonSerializable()
class CreateOrderRequest {
  final String token;
  final String fecha_programada;
  final double peso_aproximado_kg;
  final String tipo_detergente;
  final bool suavizante;
  final String metodo_secado;
  final String? tipo_planchado; // "con_gancho" o "sin_gancho"
  final int numero_prendas_planchado; // 0 si no hay planchado
  final String instrucciones_especiales;
  final String? payment_method_id;
  final double lat;
  final double lon;
  final String direccion;
  final String fecha_recogida_propuesta_cliente;
  final String fecha_entrega_propuesta_cliente;
  final bool lavado_urgente;
  final bool lavado_secado_urgente;
  final bool lavado_secado_planchado_urgente;

  const CreateOrderRequest({
    required this.token,
    required this.fecha_programada,
    required this.peso_aproximado_kg,
    required this.tipo_detergente,
    required this.suavizante,
    required this.metodo_secado,
    this.tipo_planchado,
    required this.numero_prendas_planchado,
    required this.instrucciones_especiales,
    this.payment_method_id,
    required this.lat,
    required this.lon,
    required this.direccion,
    required this.fecha_recogida_propuesta_cliente,
    required this.fecha_entrega_propuesta_cliente,
    required this.lavado_urgente,
    required this.lavado_secado_urgente,
    required this.lavado_secado_planchado_urgente,
  });

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderRequestToJson(this);
}

@JsonSerializable()
class CreateOrderRequestBody {
  final CreateOrderRequest body;

  const CreateOrderRequestBody({required this.body});

  factory CreateOrderRequestBody.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderRequestBodyToJson(this);
}
