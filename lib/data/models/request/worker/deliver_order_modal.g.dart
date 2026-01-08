// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deliver_order_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliverOrderRequest _$DeliverOrderRequestFromJson(Map<String, dynamic> json) =>
    DeliverOrderRequest(
      token: json['token'] as String,
      ordenId: (json['orden_id'] as num).toInt(),
      fotoS3Entrega: json['foto_s3_entrega'] as String?,
    );

Map<String, dynamic> _$DeliverOrderRequestToJson(
        DeliverOrderRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
      'orden_id': instance.ordenId,
      'foto_s3_entrega': instance.fotoS3Entrega,
    };
