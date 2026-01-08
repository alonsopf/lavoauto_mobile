// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rate_client_response_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RateClientResponse _$RateClientResponseFromJson(Map<String, dynamic> json) =>
    RateClientResponse(
      message: json['message'] as String,
      ratingId: (json['rating_id'] as num).toInt(),
      orderId: (json['order_id'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      clientId: (json['client_id'] as num).toInt(),
    );

Map<String, dynamic> _$RateClientResponseToJson(RateClientResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'rating_id': instance.ratingId,
      'order_id': instance.orderId,
      'rating': instance.rating,
      'client_id': instance.clientId,
    };
