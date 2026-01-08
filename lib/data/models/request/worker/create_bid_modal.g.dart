// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_bid_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateBidRequest _$CreateBidRequestFromJson(Map<String, dynamic> json) =>
    CreateBidRequest(
      token: json['token'] as String,
      ordenId: (json['orden_id'] as num).toInt(),
      precioPorKg: (json['precio_por_kg'] as num).toDouble(),
      nota: json['nota'] as String,
      fechaRecogida: json['fecha_recogida'] as String?,
      fechaEstimada: json['fecha_estimada'] as String?,
      fechaRecogidaPropuesta: json['fecha_recogida_propuesta'] as String?,
      fechaEntregaPropuesta: json['fecha_entrega_propuesta'] as String?,
    );

Map<String, dynamic> _$CreateBidRequestToJson(CreateBidRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
      'orden_id': instance.ordenId,
      'precio_por_kg': instance.precioPorKg,
      'nota': instance.nota,
      'fecha_recogida': instance.fechaRecogida,
      'fecha_estimada': instance.fechaEstimada,
      'fecha_recogida_propuesta': instance.fechaRecogidaPropuesta,
      'fecha_entrega_propuesta': instance.fechaEntregaPropuesta,
    };
