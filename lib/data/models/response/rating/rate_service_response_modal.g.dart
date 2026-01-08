// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rate_service_response_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RateServiceResponse _$RateServiceResponseFromJson(Map<String, dynamic> json) =>
    RateServiceResponse(
      message: json['message'] as String,
      ratingId: (json['rating_id'] as num).toInt(),
      orderId: (json['order_id'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      lavadorId: (json['lavador_id'] as num).toInt(),
    );

Map<String, dynamic> _$RateServiceResponseToJson(
        RateServiceResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'rating_id': instance.ratingId,
      'order_id': instance.orderId,
      'rating': instance.rating,
      'lavador_id': instance.lavadorId,
    };
