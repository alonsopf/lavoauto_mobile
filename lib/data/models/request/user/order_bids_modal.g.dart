// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_bids_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListOrderBidsRequest _$ListOrderBidsRequestFromJson(
        Map<String, dynamic> json) =>
    ListOrderBidsRequest(
      token: json['token'] as String,
      ordenId: (json['orden_id'] as num).toInt(),
    );

Map<String, dynamic> _$ListOrderBidsRequestToJson(
        ListOrderBidsRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
      'orden_id': instance.ordenId,
    };
