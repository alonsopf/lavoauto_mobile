// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_work_response_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyWorkResponse _$MyWorkResponseFromJson(Map<String, dynamic> json) =>
    MyWorkResponse(
      lavadorId: (json['lavador_id'] as num).toInt(),
      totalOrders: (json['total_orders'] as num).toInt(),
      workOrders: (json['work_orders'] as List<dynamic>?)
          ?.map((e) => MyWorkOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MyWorkResponseToJson(MyWorkResponse instance) =>
    <String, dynamic>{
      'lavador_id': instance.lavadorId,
      'total_orders': instance.totalOrders,
      'work_orders': instance.workOrders,
    };

MyWorkOrder _$MyWorkOrderFromJson(Map<String, dynamic> json) => MyWorkOrder(
      ordenId: (json['orden_id'] as num).toInt(),
      estatus: json['estatus'] as String,
      fechaProgramada: json['fecha_programada'] as String,
      pesoAproximadoKg: (json['peso_aproximado_kg'] as num?)?.toDouble(),
      tipoDetergente: json['tipo_detergente'] as String?,
      metodoSecado: json['metodo_secado'] as String?,
      instruccionesEspeciales: json['instrucciones_especiales'] as String?,
      paymentMethodId: (json['payment_method_id'] as num?)?.toInt(),
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      direccion: json['direccion'] as String?,
      clienteId: (json['cliente_id'] as num).toInt(),
      clienteFotoUrl: json['cliente_foto_url'] as String?,
      precioPorKg: (json['precio_por_kg'] as num?)?.toDouble(),
      pesoFinalKg: (json['peso_final_kg'] as num?)?.toDouble(),
      costoFinal: (json['costo_final'] as num?)?.toDouble(),
      fechaCompletada: json['fecha_completada'] as String?,
      propina: (json['propina'] as num?)?.toDouble(),
      fechaCreacion: json['fecha_creacion'] as String,
    );

Map<String, dynamic> _$MyWorkOrderToJson(MyWorkOrder instance) =>
    <String, dynamic>{
      'orden_id': instance.ordenId,
      'estatus': instance.estatus,
      'fecha_programada': instance.fechaProgramada,
      'peso_aproximado_kg': instance.pesoAproximadoKg,
      'tipo_detergente': instance.tipoDetergente,
      'metodo_secado': instance.metodoSecado,
      'instrucciones_especiales': instance.instruccionesEspeciales,
      'payment_method_id': instance.paymentMethodId,
      'lat': instance.lat,
      'lon': instance.lon,
      'direccion': instance.direccion,
      'cliente_id': instance.clienteId,
      'cliente_foto_url': instance.clienteFotoUrl,
      'precio_por_kg': instance.precioPorKg,
      'peso_final_kg': instance.pesoFinalKg,
      'costo_final': instance.costoFinal,
      'fecha_completada': instance.fechaCompletada,
      'propina': instance.propina,
      'fecha_creacion': instance.fechaCreacion,
    };
