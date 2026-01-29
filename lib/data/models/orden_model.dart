import 'package:json_annotation/json_annotation.dart';

part 'orden_model.g.dart';

enum OrdenStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

extension OrdenStatusExtension on OrdenStatus {
  String get displayName {
    switch (this) {
      case OrdenStatus.pending:
        return 'Pendiente';
      case OrdenStatus.inProgress:
        return 'En Progreso';
      case OrdenStatus.completed:
        return 'Completada';
      case OrdenStatus.cancelled:
        return 'Cancelada';
    }
  }

  String get description {
    switch (this) {
      case OrdenStatus.pending:
        return 'Esperando que el lavador comience';
      case OrdenStatus.inProgress:
        return 'El lavador está realizando el servicio';
      case OrdenStatus.completed:
        return 'Servicio completado';
      case OrdenStatus.cancelled:
        return 'Orden cancelada';
    }
  }
}

@JsonSerializable()
class LavadorInfo {
  final String nombre;
  final String? apellido;

  @JsonKey(name: 'calificacion_promedio', defaultValue: 0.0)
  final double calificacionPromedio;

  final String? telefono;

  LavadorInfo({
    required this.nombre,
    this.apellido,
    this.calificacionPromedio = 0.0,
    this.telefono,
  });

  String get nombreCompleto => '$nombre ${apellido ?? ''}'.trim();

  factory LavadorInfo.fromJson(Map<String, dynamic> json) =>
      _$LavadorInfoFromJson(json);

  Map<String, dynamic> toJson() => _$LavadorInfoToJson(this);
}

@JsonSerializable()
class VehiculoInfo {
  final String marca;
  final String modelo;
  final String categoria;
  final String? alias;
  final String? color;
  final String? placas;

  VehiculoInfo({
    required this.marca,
    required this.modelo,
    required this.categoria,
    this.alias,
    this.color,
    this.placas,
  });

  String get descripcion {
    final base = '$marca $modelo';
    if (alias != null && alias!.isNotEmpty) {
      return '$base ($alias)';
    }
    return base;
  }

  factory VehiculoInfo.fromJson(Map<String, dynamic> json) =>
      _$VehiculoInfoFromJson(json);

  Map<String, dynamic> toJson() => _$VehiculoInfoToJson(this);
}

@JsonSerializable()
class ClienteInfo {
  final String nombre;
  final String apellidos;
  final String? telefono;
  final String? direccion;

  ClienteInfo({
    required this.nombre,
    required this.apellidos,
    this.telefono,
    this.direccion,
  });

  String get nombreCompleto => '$nombre $apellidos';

  factory ClienteInfo.fromJson(Map<String, dynamic> json) =>
      _$ClienteInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ClienteInfoToJson(this);
}

@JsonSerializable()
class OrdenModel {
  @JsonKey(name: 'orden_id')
  final int ordenId;

  final OrdenStatus status;

  @JsonKey(name: 'distancia_km', defaultValue: 0.0)
  final double distanciaKm;

  @JsonKey(name: 'precio_servicio', defaultValue: 0.0)
  final double precioServicio;

  @JsonKey(name: 'precio_distancia', defaultValue: 0.0)
  final double precioDistancia;

  @JsonKey(name: 'precio_total', defaultValue: 0.0)
  final double precioTotal;

  @JsonKey(name: 'created_at', defaultValue: '')
  final String createdAt;

  @JsonKey(name: 'started_at')
  final String? startedAt;

  @JsonKey(name: 'completed_at')
  final String? completedAt;

  @JsonKey(name: 'fecha_esperada')
  final String? fechaEsperada;

  @JsonKey(name: 'notas_cliente')
  final String? notasCliente;

  @JsonKey(name: 'tipo_servicio_id')
  final int? tipoServicioId;

  @JsonKey(name: 'nombre_servicio')
  final String? nombreServicio;

  final LavadorInfo? lavador;
  final VehiculoInfo? vehiculo;
  final ClienteInfo? cliente;

  OrdenModel({
    required this.ordenId,
    required this.status,
    this.distanciaKm = 0.0,
    this.precioServicio = 0.0,
    this.precioDistancia = 0.0,
    this.precioTotal = 0.0,
    this.createdAt = '',
    this.startedAt,
    this.completedAt,
    this.fechaEsperada,
    this.notasCliente,
    this.tipoServicioId,
    this.nombreServicio,
    this.lavador,
    this.vehiculo,
    this.cliente,
  });

  String get precioTotalFormateado => '\$${precioTotal.toStringAsFixed(2)}';
  String get precioServicioFormateado => '\$${precioServicio.toStringAsFixed(2)}';
  String get precioDistanciaFormateado => '\$${precioDistancia.toStringAsFixed(2)}';
  String get distanciaFormateada => '${distanciaKm.toStringAsFixed(1)} km';

  // Backward compatibility
  double get precioBase => precioServicio;
  String get precioBaseFormateado => precioServicioFormateado;

  factory OrdenModel.fromJson(Map<String, dynamic> json) =>
      _$OrdenModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrdenModelToJson(this);
}

@JsonSerializable()
class OrdenesResponse {
  final List<OrdenModel> ordenes;

  OrdenesResponse({required this.ordenes});

  factory OrdenesResponse.fromJson(Map<String, dynamic> json) =>
      _$OrdenesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrdenesResponseToJson(this);
}

@JsonSerializable()
class CrearOrdenResponse {
  @JsonKey(name: 'orden_id')
  final int ordenId;

  final String message;

  CrearOrdenResponse({
    required this.ordenId,
    required this.message,
  });

  factory CrearOrdenResponse.fromJson(Map<String, dynamic> json) =>
      _$CrearOrdenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CrearOrdenResponseToJson(this);
}

@JsonSerializable()
class LavadorOrdenesActivasResponse {
  @JsonKey(name: 'lavador_id')
  final int lavadorId;

  @JsonKey(name: 'tiene_activas')
  final bool tieneActivas;

  LavadorOrdenesActivasResponse({
    required this.lavadorId,
    required this.tieneActivas,
  });

  factory LavadorOrdenesActivasResponse.fromJson(Map<String, dynamic> json) =>
      _$LavadorOrdenesActivasResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LavadorOrdenesActivasResponseToJson(this);
}
