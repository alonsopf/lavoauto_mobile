// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rate_service_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RateServiceRequest _$RateServiceRequestFromJson(Map<String, dynamic> json) =>
    RateServiceRequest(
      token: json['token'] as String,
      orderId: (json['order_id'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      comentarios: json['comentarios'] as String,
    );

Map<String, dynamic> _$RateServiceRequestToJson(RateServiceRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
      'order_id': instance.orderId,
      'rating': instance.rating,
      'comentarios': instance.comentarios,
    };
