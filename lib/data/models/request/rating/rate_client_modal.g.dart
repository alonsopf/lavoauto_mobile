// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rate_client_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RateClientRequest _$RateClientRequestFromJson(Map<String, dynamic> json) =>
    RateClientRequest(
      token: json['token'] as String,
      orderId: (json['order_id'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      comentarios: json['comentarios'] as String,
    );

Map<String, dynamic> _$RateClientRequestToJson(RateClientRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
      'order_id': instance.orderId,
      'rating': instance.rating,
      'comentarios': instance.comentarios,
    };
