import 'package:json_annotation/json_annotation.dart';

part 'lavador_cercano_model.g.dart';

@JsonSerializable()
class ServicioPrecio {
  @JsonKey(name: 'precio_id')
  final int precioId;

  @JsonKey(name: 'categoria_vehiculo')
  final String categoriaVehiculo;

  final double precio;

  @JsonKey(name: 'duracion_estimada')
  final int duracionEstimada;

  ServicioPrecio({
    required this.precioId,
    required this.categoriaVehiculo,
    required this.precio,
    required this.duracionEstimada,
  });

  String get precioFormateado => '\$${precio.toStringAsFixed(2)}';

  String get duracionFormateada {
    if (duracionEstimada < 60) {
      return '${duracionEstimada}min';
    } else {
      final horas = duracionEstimada ~/ 60;
      final mins = duracionEstimada % 60;
      return mins > 0 ? '${horas}h ${mins}min' : '${horas}h';
    }
  }

  factory ServicioPrecio.fromJson(Map<String, dynamic> json) =>
      _$ServicioPrecioFromJson(json);

  Map<String, dynamic> toJson() => _$ServicioPrecioToJson(this);
}

@JsonSerializable()
class ServicioLavador {
  @JsonKey(name: 'tipo_servicio_id')
  final int tipoServicioId;

  final String nombre;
  final String? descripcion;
  final List<ServicioPrecio> precios;

  ServicioLavador({
    required this.tipoServicioId,
    required this.nombre,
    this.descripcion,
    required this.precios,
  });

  factory ServicioLavador.fromJson(Map<String, dynamic> json) =>
      _$ServicioLavadorFromJson(json);

  Map<String, dynamic> toJson() => _$ServicioLavadorToJson(this);
}

@JsonSerializable()
class LavadorCercano {
  @JsonKey(name: 'lavador_id')
  final int lavadorId;

  final String nombre;
  final String apellido;
  final String? telefono;
  final String? email;
  final String? direccion;

  @JsonKey(name: 'foto_url')
  final String? fotoUrl;

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

  final List<ServicioLavador>? servicios;

  LavadorCercano({
    required this.lavadorId,
    required this.nombre,
    required this.apellido,
    this.telefono,
    this.email,
    this.direccion,
    this.fotoUrl,
    required this.precioKm,
    required this.calificacionPromedio,
    required this.distanciaMetros,
    required this.distanciaKm,
    required this.duracionSegundos,
    this.servicios,
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

  @JsonKey(name: 'cliente_direccion')
  final String? clienteDireccion;

  LavadoresCercanosResponse({
    required this.lavadores,
    this.clienteDireccion,
  });

  factory LavadoresCercanosResponse.fromJson(Map<String, dynamic> json) =>
      _$LavadoresCercanosResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LavadoresCercanosResponseToJson(this);
}
