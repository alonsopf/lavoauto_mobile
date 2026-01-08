// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_bids_response_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderBidsResponse _$OrderBidsResponseFromJson(Map<String, dynamic> json) =>
    OrderBidsResponse(
      pujas: (json['pujas'] as List<dynamic>?)
          ?.map((e) => OrderBid.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderBidsResponseToJson(OrderBidsResponse instance) =>
    <String, dynamic>{
      'pujas': instance.pujas,
    };

OrderBid _$OrderBidFromJson(Map<String, dynamic> json) => OrderBid(
      pujaId: (json['puja_id'] as num).toInt(),
      lavadorId: (json['lavador_id'] as num).toInt(),
      lavadorNombre: json['lavador_nombre'] as String?,
      lavadorFotoUrl: json['lavador_foto_url'] as String?,
      lavadorRating: _doubleFromJson(json['lavador_rating']),
      precioPorKg: _doubleFromJson(json['precio_por_kg']),
      nota: json['nota'] as String,
      fechaRecogida: json['fecha_recogida'] as String?,
      fechaEstimada: json['fecha_estimada'] as String?,
      fechaRecogidaPropuesta: json['fecha_recogida_propuesta'] as String?,
      fechaEntregaPropuesta: json['fecha_entrega_propuesta'] as String?,
      status: json['status'] as String,
      fechaCreacion: json['fecha_creacion'] as String,
    );

Map<String, dynamic> _$OrderBidToJson(OrderBid instance) => <String, dynamic>{
      'puja_id': instance.pujaId,
      'lavador_id': instance.lavadorId,
      'lavador_nombre': instance.lavadorNombre,
      'lavador_foto_url': instance.lavadorFotoUrl,
      'lavador_rating': instance.lavadorRating,
      'precio_por_kg': instance.precioPorKg,
      'nota': instance.nota,
      'fecha_recogida': instance.fechaRecogida,
      'fecha_estimada': instance.fechaEstimada,
      'fecha_recogida_propuesta': instance.fechaRecogidaPropuesta,
      'fecha_entrega_propuesta': instance.fechaEntregaPropuesta,
      'status': instance.status,
      'fecha_creacion': instance.fechaCreacion,
    };
