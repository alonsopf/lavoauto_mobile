// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrderRequest _$CreateOrderRequestFromJson(Map<String, dynamic> json) =>
    CreateOrderRequest(
      token: json['token'] as String,
      fecha_programada: json['fecha_programada'] as String,
      peso_aproximado_kg: (json['peso_aproximado_kg'] as num).toDouble(),
      tipo_detergente: json['tipo_detergente'] as String,
      suavizante: json['suavizante'] as bool,
      metodo_secado: json['metodo_secado'] as String,
      tipo_planchado: json['tipo_planchado'] as String?,
      numero_prendas_planchado:
          (json['numero_prendas_planchado'] as num).toInt(),
      instrucciones_especiales: json['instrucciones_especiales'] as String,
      payment_method_id: json['payment_method_id'] as String?,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      direccion: json['direccion'] as String,
      fecha_recogida_propuesta_cliente:
          json['fecha_recogida_propuesta_cliente'] as String,
      fecha_entrega_propuesta_cliente:
          json['fecha_entrega_propuesta_cliente'] as String,
      lavado_urgente: json['lavado_urgente'] as bool,
      lavado_secado_urgente: json['lavado_secado_urgente'] as bool,
      lavado_secado_planchado_urgente:
          json['lavado_secado_planchado_urgente'] as bool,
    );

Map<String, dynamic> _$CreateOrderRequestToJson(CreateOrderRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
      'fecha_programada': instance.fecha_programada,
      'peso_aproximado_kg': instance.peso_aproximado_kg,
      'tipo_detergente': instance.tipo_detergente,
      'suavizante': instance.suavizante,
      'metodo_secado': instance.metodo_secado,
      'tipo_planchado': instance.tipo_planchado,
      'numero_prendas_planchado': instance.numero_prendas_planchado,
      'instrucciones_especiales': instance.instrucciones_especiales,
      'payment_method_id': instance.payment_method_id,
      'lat': instance.lat,
      'lon': instance.lon,
      'direccion': instance.direccion,
      'fecha_recogida_propuesta_cliente':
          instance.fecha_recogida_propuesta_cliente,
      'fecha_entrega_propuesta_cliente':
          instance.fecha_entrega_propuesta_cliente,
      'lavado_urgente': instance.lavado_urgente,
      'lavado_secado_urgente': instance.lavado_secado_urgente,
      'lavado_secado_planchado_urgente':
          instance.lavado_secado_planchado_urgente,
    };

CreateOrderRequestBody _$CreateOrderRequestBodyFromJson(
        Map<String, dynamic> json) =>
    CreateOrderRequestBody(
      body: CreateOrderRequest.fromJson(json['body'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateOrderRequestBodyToJson(
        CreateOrderRequestBody instance) =>
    <String, dynamic>{
      'body': instance.body,
    };
