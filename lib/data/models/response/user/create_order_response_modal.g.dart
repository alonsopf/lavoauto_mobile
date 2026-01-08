// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_response_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrderResponse _$CreateOrderResponseFromJson(Map<String, dynamic> json) =>
    CreateOrderResponse(
      message: json['message'] as String?,
      ordenId: (json['orden_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CreateOrderResponseToJson(
        CreateOrderResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'orden_id': instance.ordenId,
    };
