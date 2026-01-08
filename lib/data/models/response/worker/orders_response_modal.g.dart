// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_response_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkerOrdersResponse _$WorkerOrdersResponseFromJson(
        Map<String, dynamic> json) =>
    WorkerOrdersResponse(
      orders: (json['orders'] as List<dynamic>?)
          ?.map((e) => WorkerOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WorkerOrdersResponseToJson(
        WorkerOrdersResponse instance) =>
    <String, dynamic>{
      'orders': instance.orders,
    };

WorkerOrder _$WorkerOrderFromJson(Map<String, dynamic> json) => WorkerOrder(
      ordenId: (json['orden_id'] as num).toInt(),
      estatus: json['estatus'] as String,
      fechaProgramada: json['fecha_programada'] as String,
      pesoAproximadoKg: _doubleFromJson(json['peso_aproximado_kg']),
      tipoDetergente: json['tipo_detergente'] as String?,
      metodoSecado: json['metodo_secado'] as String?,
      instruccionesEspeciales: json['instrucciones_especiales'] as String?,
      paymentMethodId: (json['payment_method_id'] as num?)?.toInt(),
      lat: _doubleFromJson(json['lat']),
      lon: _doubleFromJson(json['lon']),
      direccion: json['direccion'] as String?,
      clienteId: (json['cliente_id'] as num).toInt(),
    );

Map<String, dynamic> _$WorkerOrderToJson(WorkerOrder instance) =>
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
    };
