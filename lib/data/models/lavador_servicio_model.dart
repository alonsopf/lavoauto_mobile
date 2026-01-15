import 'package:json_annotation/json_annotation.dart';
import 'servicio_precio_model.dart';

part 'lavador_servicio_model.g.dart';

@JsonSerializable()
class LavadorServicioModel {
  @JsonKey(name: 'tipo_servicio_id')
  final int tipoServicioId;
  final String nombre;
  final String? descripcion;
  final List<ServicioPrecioModel> precios;

  LavadorServicioModel({
    required this.tipoServicioId,
    required this.nombre,
    this.descripcion,
    required this.precios,
  });

  factory LavadorServicioModel.fromJson(Map<String, dynamic> json) =>
      _$LavadorServicioModelFromJson(json);

  Map<String, dynamic> toJson() => _$LavadorServicioModelToJson(this);

  bool get hasPrecios => precios.isNotEmpty;

  // Get price for specific vehicle category
  ServicioPrecioModel? getPrecioForCategoria(String categoria) {
    try {
      return precios.firstWhere((p) => p.categoriaVehiculo == categoria);
    } catch (e) {
      return null;
    }
  }
}
