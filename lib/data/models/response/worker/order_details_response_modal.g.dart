// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_details_response_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetailsResponse _$OrderDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    OrderDetailsResponse(
      orders: (json['orders'] as List<dynamic>?)
          ?.map((e) => OrderDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderDetailsResponseToJson(
        OrderDetailsResponse instance) =>
    <String, dynamic>{
      'orders': instance.orders,
    };

OrderDetail _$OrderDetailFromJson(Map<String, dynamic> json) => OrderDetail(
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
      precioPorKg: (json['precio_por_kg'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$OrderDetailToJson(OrderDetail instance) =>
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
      'precio_por_kg': instance.precioPorKg,
    };
