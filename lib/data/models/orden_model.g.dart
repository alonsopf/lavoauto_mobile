// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orden_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LavadorInfo _$LavadorInfoFromJson(Map<String, dynamic> json) => LavadorInfo(
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String?,
      calificacionPromedio:
          (json['calificacion_promedio'] as num?)?.toDouble() ?? 0.0,
      telefono: json['telefono'] as String?,
    );

Map<String, dynamic> _$LavadorInfoToJson(LavadorInfo instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'apellido': instance.apellido,
      'calificacion_promedio': instance.calificacionPromedio,
      'telefono': instance.telefono,
    };

VehiculoInfo _$VehiculoInfoFromJson(Map<String, dynamic> json) => VehiculoInfo(
      marca: json['marca'] as String,
      modelo: json['modelo'] as String,
      categoria: json['categoria'] as String,
      alias: json['alias'] as String?,
      color: json['color'] as String?,
      placas: json['placas'] as String?,
    );

Map<String, dynamic> _$VehiculoInfoToJson(VehiculoInfo instance) =>
    <String, dynamic>{
      'marca': instance.marca,
      'modelo': instance.modelo,
      'categoria': instance.categoria,
      'alias': instance.alias,
      'color': instance.color,
      'placas': instance.placas,
    };

ClienteInfo _$ClienteInfoFromJson(Map<String, dynamic> json) => ClienteInfo(
      nombre: json['nombre'] as String,
      apellidos: json['apellidos'] as String,
      telefono: json['telefono'] as String?,
      direccion: json['direccion'] as String?,
    );

Map<String, dynamic> _$ClienteInfoToJson(ClienteInfo instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'apellidos': instance.apellidos,
      'telefono': instance.telefono,
      'direccion': instance.direccion,
    };

OrdenModel _$OrdenModelFromJson(Map<String, dynamic> json) => OrdenModel(
      ordenId: (json['orden_id'] as num).toInt(),
      status: $enumDecode(_$OrdenStatusEnumMap, json['status']),
      distanciaKm: (json['distancia_km'] as num?)?.toDouble() ?? 0.0,
      precioServicio: (json['precio_servicio'] as num?)?.toDouble() ?? 0.0,
      precioDistancia: (json['precio_distancia'] as num?)?.toDouble() ?? 0.0,
      precioTotal: (json['precio_total'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'] as String? ?? '',
      startedAt: json['started_at'] as String?,
      completedAt: json['completed_at'] as String?,
      fechaEsperada: json['fecha_esperada'] as String?,
      notasCliente: json['notas_cliente'] as String?,
      tipoServicioId: (json['tipo_servicio_id'] as num?)?.toInt(),
      nombreServicio: json['nombre_servicio'] as String?,
      lavador: json['lavador'] == null
          ? null
          : LavadorInfo.fromJson(json['lavador'] as Map<String, dynamic>),
      vehiculo: json['vehiculo'] == null
          ? null
          : VehiculoInfo.fromJson(json['vehiculo'] as Map<String, dynamic>),
      cliente: json['cliente'] == null
          ? null
          : ClienteInfo.fromJson(json['cliente'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrdenModelToJson(OrdenModel instance) =>
    <String, dynamic>{
      'orden_id': instance.ordenId,
      'status': _$OrdenStatusEnumMap[instance.status]!,
      'distancia_km': instance.distanciaKm,
      'precio_servicio': instance.precioServicio,
      'precio_distancia': instance.precioDistancia,
      'precio_total': instance.precioTotal,
      'created_at': instance.createdAt,
      'started_at': instance.startedAt,
      'completed_at': instance.completedAt,
      'fecha_esperada': instance.fechaEsperada,
      'notas_cliente': instance.notasCliente,
      'tipo_servicio_id': instance.tipoServicioId,
      'nombre_servicio': instance.nombreServicio,
      'lavador': instance.lavador,
      'vehiculo': instance.vehiculo,
      'cliente': instance.cliente,
    };

const _$OrdenStatusEnumMap = {
  OrdenStatus.pending: 'pending',
  OrdenStatus.inProgress: 'in_progress',
  OrdenStatus.completed: 'completed',
  OrdenStatus.cancelled: 'cancelled',
};

OrdenesResponse _$OrdenesResponseFromJson(Map<String, dynamic> json) =>
    OrdenesResponse(
      ordenes: (json['ordenes'] as List<dynamic>)
          .map((e) => OrdenModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrdenesResponseToJson(OrdenesResponse instance) =>
    <String, dynamic>{
      'ordenes': instance.ordenes,
    };

CrearOrdenResponse _$CrearOrdenResponseFromJson(Map<String, dynamic> json) =>
    CrearOrdenResponse(
      ordenId: (json['orden_id'] as num).toInt(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$CrearOrdenResponseToJson(CrearOrdenResponse instance) =>
    <String, dynamic>{
      'orden_id': instance.ordenId,
      'message': instance.message,
    };

LavadorOrdenesActivasResponse _$LavadorOrdenesActivasResponseFromJson(
        Map<String, dynamic> json) =>
    LavadorOrdenesActivasResponse(
      lavadorId: (json['lavador_id'] as num).toInt(),
      tieneActivas: json['tiene_activas'] as bool,
    );

Map<String, dynamic> _$LavadorOrdenesActivasResponseToJson(
        LavadorOrdenesActivasResponse instance) =>
    <String, dynamic>{
      'lavador_id': instance.lavadorId,
      'tiene_activas': instance.tieneActivas,
    };
