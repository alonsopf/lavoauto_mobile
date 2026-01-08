// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collect_order_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectOrderRequest _$CollectOrderRequestFromJson(Map<String, dynamic> json) =>
    CollectOrderRequest(
      token: json['token'] as String,
      ordenId: (json['orden_id'] as num).toInt(),
      pesoFinalKg: (json['peso_final_kg'] as num).toDouble(),
    );

Map<String, dynamic> _$CollectOrderRequestToJson(
        CollectOrderRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
      'orden_id': instance.ordenId,
      'peso_final_kg': instance.pesoFinalKg,
    };
