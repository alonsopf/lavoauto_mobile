// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lavador_order_detail_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LavadorOrderDetailRequest _$LavadorOrderDetailRequestFromJson(
        Map<String, dynamic> json) =>
    LavadorOrderDetailRequest(
      token: json['token'] as String,
      orderId: (json['order_id'] as num).toInt(),
    );

Map<String, dynamic> _$LavadorOrderDetailRequestToJson(
        LavadorOrderDetailRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
      'order_id': instance.orderId,
    };
