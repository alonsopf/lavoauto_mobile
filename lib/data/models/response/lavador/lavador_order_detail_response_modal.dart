import 'package:json_annotation/json_annotation.dart';

part 'lavador_order_detail_response_modal.g.dart';

@JsonSerializable()
class LavadorOrderDetailResponse {
  @JsonKey(name: 'orden_id')
  final int ordenId;

  @JsonKey(name: 'estatus')
  final String estatus;

  @JsonKey(name: 'fecha_programada')
  final String fechaProgramada;

  @JsonKey(name: 'peso_aproximado_kg')
  final double pesoAproximadoKg;

  @JsonKey(name: 'tipo_detergente')
  final String tipoDetergente;

  @JsonKey(name: 'metodo_secado')
  final String metodoSecado;

  @JsonKey(name: 'instrucciones_especiales')
  final String instruccionesEspeciales;

  @JsonKey(name: 'payment_method_id')
  final int paymentMethodId;

  @JsonKey(name: 'lat')
  final double lat;

  @JsonKey(name: 'lon')
  final double lon;

  @JsonKey(name: 'direccion')
  final String direccion;

  @JsonKey(name: 'cliente_id')
  final int clienteId;

  @JsonKey(name: 'precio_por_kg')
  final double? precioPorKg;

  @JsonKey(name: 'fecha_completada')
  final String? fechaCompletada;

  @JsonKey(name: 'propina')
  final double? propina;

  @JsonKey(name: 'peso_final_kg')
  final double? pesoFinalKg;

  LavadorOrderDetailResponse({
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
    this.precioPorKg,
    this.fechaCompletada,
    this.propina,
    this.pesoFinalKg,
  });

  factory LavadorOrderDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$LavadorOrderDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LavadorOrderDetailResponseToJson(this);
}