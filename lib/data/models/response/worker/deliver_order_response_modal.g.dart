// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deliver_order_response_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliverOrderResponse _$DeliverOrderResponseFromJson(
        Map<String, dynamic> json) =>
    DeliverOrderResponse(
      lavadorId: (json['lavador_id'] as num).toInt(),
      message: json['message'] as String,
      ordenId: (json['orden_id'] as num).toInt(),
    );

Map<String, dynamic> _$DeliverOrderResponseToJson(
        DeliverOrderResponse instance) =>
    <String, dynamic>{
      'lavador_id': instance.lavadorId,
      'message': instance.message,
      'orden_id': instance.ordenId,
    };
