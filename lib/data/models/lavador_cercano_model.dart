import 'package:json_annotation/json_annotation.dart';

part 'lavador_cercano_model.g.dart';

@JsonSerializable()
class LavadorCercano {
  @JsonKey(name: 'lavador_id')
  final int lavadorId;

  final String nombre;
  final String apellido;
  final String? telefono;
  final String? email;
  final String? direccion;

  @JsonKey(name: 'precio_km')
  final double precioKm;

  @JsonKey(name: 'calificacion_promedio')
  final double calificacionPromedio;

  @JsonKey(name: 'distancia_metros')
  final int distanciaMetros;

  @JsonKey(name: 'distancia_km')
  final double distanciaKm;

  @JsonKey(name: 'duracion_segundos')
  final int duracionSegundos;

  LavadorCercano({
    required this.lavadorId,
    required this.nombre,
    required this.apellido,
    this.telefono,
    this.email,
    this.direccion,
    required this.precioKm,
    required this.calificacionPromedio,
    required this.distanciaMetros,
    required this.distanciaKm,
    required this.duracionSegundos,
  });

  String get nombreCompleto => '$nombre $apellido';

  String get distanciaFormateada {
    if (distanciaKm < 1) {
      return '${distanciaMetros}m';
    } else if (distanciaKm < 10) {
      return '${distanciaKm.toStringAsFixed(1)}km';
    } else {
      return '${distanciaKm.toStringAsFixed(0)}km';
    }
  }

  String get duracionFormateada {
    final minutos = duracionSegundos ~/ 60;
    if (minutos < 1) {
      return '${duracionSegundos}seg';
    } else if (minutos < 60) {
      return '${minutos}min';
    } else {
      final horas = minutos ~/ 60;
      final mins = minutos % 60;
      return '${horas}h ${mins}min';
    }
  }

  String get precioFormateado => '\$${precioKm.toStringAsFixed(2)}/km';

  factory LavadorCercano.fromJson(Map<String, dynamic> json) =>
      _$LavadorCercanoFromJson(json);

  Map<String, dynamic> toJson() => _$LavadorCercanoToJson(this);
}

@JsonSerializable()
class LavadoresCercanosResponse {
  final List<LavadorCercano> lavadores;

  LavadoresCercanosResponse({required this.lavadores});

  factory LavadoresCercanosResponse.fromJson(Map<String, dynamic> json) =>
      _$LavadoresCercanosResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LavadoresCercanosResponseToJson(this);
}
