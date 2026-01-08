// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_bid_response_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderBidResponse _$OrderBidResponseFromJson(Map<String, dynamic> json) =>
    OrderBidResponse(
      message: json['message'] as String?,
      pujaId: (json['puja_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OrderBidResponseToJson(OrderBidResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'puja_id': instance.pujaId,
    };
