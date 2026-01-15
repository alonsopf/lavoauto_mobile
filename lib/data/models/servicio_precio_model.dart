import 'package:json_annotation/json_annotation.dart';

part 'servicio_precio_model.g.dart';

@JsonSerializable()
class ServicioPrecioModel {
  @JsonKey(name: 'precio_id')
  final int precioId;
  @JsonKey(name: 'categoria_vehiculo')
  final String categoriaVehiculo;
  final double precio;
  @JsonKey(name: 'duracion_estimada')
  final int duracionEstimada;
  final bool disponible;

  ServicioPrecioModel({
    required this.precioId,
    required this.categoriaVehiculo,
    required this.precio,
    required this.duracionEstimada,
    required this.disponible,
  });

  factory ServicioPrecioModel.fromJson(Map<String, dynamic> json) =>
      _$ServicioPrecioModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServicioPrecioModelToJson(this);

  ServicioPrecioModel copyWith({
    int? precioId,
    String? categoriaVehiculo,
    double? precio,
    int? duracionEstimada,
    bool? disponible,
  }) {
    return ServicioPrecioModel(
      precioId: precioId ?? this.precioId,
      categoriaVehiculo: categoriaVehiculo ?? this.categoriaVehiculo,
      precio: precio ?? this.precio,
      duracionEstimada: duracionEstimada ?? this.duracionEstimada,
      disponible: disponible ?? this.disponible,
    );
  }
}
