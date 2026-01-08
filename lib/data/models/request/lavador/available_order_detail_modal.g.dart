// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_order_detail_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvailableOrderDetailRequest _$AvailableOrderDetailRequestFromJson(
        Map<String, dynamic> json) =>
    AvailableOrderDetailRequest(
      token: json['token'] as String,
      orderId: (json['order_id'] as num).toInt(),
    );

Map<String, dynamic> _$AvailableOrderDetailRequestToJson(
        AvailableOrderDetailRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
      'order_id': instance.orderId,
    };
