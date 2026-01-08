// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_user_order_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateUserOrderRequest _$CreateUserOrderRequestFromJson(
        Map<String, dynamic> json) =>
    CreateUserOrderRequest(
      token: json['token'] as String,
      fechaProgramada: json['fecha_programada'] as String,
      pesoAproximadoKg: (json['peso_aproximado_kg'] as num).toDouble(),
      tipoDetergente: json['tipo_detergente'] as String,
      suavizante: json['suavizante'] as bool,
      metodoSecado: json['metodo_secado'] as String,
      tipoPlanchado: json['tipo_planchado'] as String?,
      numeroPrendasPlanchado:
          (json['numero_prendas_planchado'] as num?)?.toInt() ?? 0,
      instruccionesEspeciales: json['instrucciones_especiales'] as String,
      paymentMethodId: json['payment_method_id'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      direccion: json['direccion'] as String,
      fechaRecogidaPropuestaCliente:
          json['fecha_recogida_propuesta_cliente'] as String?,
      fechaEntregaPropuestaCliente:
          json['fecha_entrega_propuesta_cliente'] as String?,
      lavadoUrgente: json['lavado_urgente'] as bool? ?? false,
      lavadoSecadoUrgente: json['lavado_secado_urgente'] as bool? ?? false,
      lavadoSecadoPlanchadoUrgente:
          json['lavado_secado_planchado_urgente'] as bool? ?? false,
    );

Map<String, dynamic> _$CreateUserOrderRequestToJson(
        CreateUserOrderRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
      'fecha_programada': instance.fechaProgramada,
      'peso_aproximado_kg': instance.pesoAproximadoKg,
      'tipo_detergente': instance.tipoDetergente,
      'suavizante': instance.suavizante,
      'metodo_secado': instance.metodoSecado,
      'tipo_planchado': instance.tipoPlanchado,
      'numero_prendas_planchado': instance.numeroPrendasPlanchado,
      'instrucciones_especiales': instance.instruccionesEspeciales,
      'payment_method_id': instance.paymentMethodId,
      'lat': instance.lat,
      'lon': instance.lon,
      'direccion': instance.direccion,
      'fecha_recogida_propuesta_cliente':
          instance.fechaRecogidaPropuestaCliente,
      'fecha_entrega_propuesta_cliente': instance.fechaEntregaPropuestaCliente,
      'lavado_urgente': instance.lavadoUrgente,
      'lavado_secado_urgente': instance.lavadoSecadoUrgente,
      'lavado_secado_planchado_urgente': instance.lavadoSecadoPlanchadoUrgente,
    };
