// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accept_bid_order_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcceptBidOrderRequest _$AcceptBidOrderRequestFromJson(
        Map<String, dynamic> json) =>
    AcceptBidOrderRequest(
      token: json['token'] as String,
      ordenId: (json['orden_id'] as num).toInt(),
      pujaId: (json['puja_id'] as num).toInt(),
    );

Map<String, dynamic> _$AcceptBidOrderRequestToJson(
        AcceptBidOrderRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
      'orden_id': instance.ordenId,
      'puja_id': instance.pujaId,
    };
