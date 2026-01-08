// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_response_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserOrdersResponse _$UserOrdersResponseFromJson(Map<String, dynamic> json) =>
    UserOrdersResponse(
      orders: (json['orders'] as List<dynamic>?)
          ?.map((e) => UserOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserOrdersResponseToJson(UserOrdersResponse instance) =>
    <String, dynamic>{
      'orders': instance.orders,
    };

UserOrder _$UserOrderFromJson(Map<String, dynamic> json) => UserOrder(
      ordenId: (json['orden_id'] as num).toInt(),
      estatus: json['estatus'] as String,
      fechaProgramada: json['fecha_programada'] as String,
      pesoAproximadoKg: (json['peso_aproximado_kg'] as num?)?.toDouble(),
      tipoDetergente: json['tipo_detergente'] as String?,
      suavizante: json['suavizante'] as bool?,
      metodoSecado: json['metodo_secado'] as String?,
      tipoPlanchado: json['tipo_planchado'] as String?,
      numeroPrendasPlanchado:
          (json['numero_prendas_planchado'] as num?)?.toInt(),
      instruccionesEspeciales: json['instrucciones_especiales'] as String?,
      paymentMethodId: (json['payment_method_id'] as num?)?.toInt(),
      paymentCardLast4: json['payment_card_last4'] as String?,
      paymentCardType: json['payment_card_type'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      direccion: json['direccion'] as String?,
      lavadorId: (json['lavador_id'] as num?)?.toInt(),
      lavadorFotoUrl: json['lavador_foto_url'] as String?,
      fechaRecogidaPropuestaCliente:
          json['fecha_recogida_propuesta_cliente'] as String?,
      fechaEntregaPropuestaCliente:
          json['fecha_entrega_propuesta_cliente'] as String?,
      fechaRecogidaPropuestaLavador:
          json['fecha_recogida_propuesta_lavador'] as String?,
      fechaEntregaPropuestaLavador:
          json['fecha_entrega_propuesta_lavador'] as String?,
      lavadoUrgente: json['lavado_urgente'] as bool?,
      lavadoSecadoUrgente: json['lavado_secado_urgente'] as bool?,
      lavadoSecadoPlanchadoUrgente:
          json['lavado_secado_planchado_urgente'] as bool?,
    );

Map<String, dynamic> _$UserOrderToJson(UserOrder instance) => <String, dynamic>{
      'orden_id': instance.ordenId,
      'estatus': instance.estatus,
      'fecha_programada': instance.fechaProgramada,
      'peso_aproximado_kg': instance.pesoAproximadoKg,
      'tipo_detergente': instance.tipoDetergente,
      'suavizante': instance.suavizante,
      'metodo_secado': instance.metodoSecado,
      'tipo_planchado': instance.tipoPlanchado,
      'numero_prendas_planchado': instance.numeroPrendasPlanchado,
      'instrucciones_especiales': instance.instruccionesEspeciales,
      'payment_method_id': instance.paymentMethodId,
      'payment_card_last4': instance.paymentCardLast4,
      'payment_card_type': instance.paymentCardType,
      'lat': instance.lat,
      'lon': instance.lon,
      'direccion': instance.direccion,
      'lavador_id': instance.lavadorId,
      'lavador_foto_url': instance.lavadorFotoUrl,
      'fecha_recogida_propuesta_cliente':
          instance.fechaRecogidaPropuestaCliente,
      'fecha_entrega_propuesta_cliente': instance.fechaEntregaPropuestaCliente,
      'fecha_recogida_propuesta_lavador':
          instance.fechaRecogidaPropuestaLavador,
      'fecha_entrega_propuesta_lavador': instance.fechaEntregaPropuestaLavador,
      'lavado_urgente': instance.lavadoUrgente,
      'lavado_secado_urgente': instance.lavadoSecadoUrgente,
      'lavado_secado_planchado_urgente': instance.lavadoSecadoPlanchadoUrgente,
    };
