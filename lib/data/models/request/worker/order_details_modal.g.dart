// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_details_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetailsRequest _$OrderDetailsRequestFromJson(Map<String, dynamic> json) =>
    OrderDetailsRequest(
      token: json['token'] as String,
      orderId: (json['order_id'] as num).toInt(),
    );

Map<String, dynamic> _$OrderDetailsRequestToJson(
        OrderDetailsRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
      'order_id': instance.orderId,
    };
