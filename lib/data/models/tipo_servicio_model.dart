import 'package:json_annotation/json_annotation.dart';

part 'tipo_servicio_model.g.dart';

@JsonSerializable()
class TipoServicioModel {
  @JsonKey(name: 'tipo_servicio_id')
  final int tipoServicioId;
  final String nombre;
  final String? descripcion;

  TipoServicioModel({
    required this.tipoServicioId,
    required this.nombre,
    this.descripcion,
  });

  factory TipoServicioModel.fromJson(Map<String, dynamic> json) =>
      _$TipoServicioModelFromJson(json);

  Map<String, dynamic> toJson() => _$TipoServicioModelToJson(this);
}
