// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_bid_accept_response_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderBidAcceptResponse _$OrderBidAcceptResponseFromJson(
        Map<String, dynamic> json) =>
    OrderBidAcceptResponse(
      lavadorId: (json['lavador_id'] as num).toInt(),
      message: json['message'] as String,
      ordenId: (json['orden_id'] as num).toInt(),
      pujaId: (json['puja_id'] as num).toInt(),
      pujasRejected: json['pujas_rejected'] as bool,
    );

Map<String, dynamic> _$OrderBidAcceptResponseToJson(
        OrderBidAcceptResponse instance) =>
    <String, dynamic>{
      'lavador_id': instance.lavadorId,
      'message': instance.message,
      'orden_id': instance.ordenId,
      'puja_id': instance.pujaId,
      'pujas_rejected': instance.pujasRejected,
    };
