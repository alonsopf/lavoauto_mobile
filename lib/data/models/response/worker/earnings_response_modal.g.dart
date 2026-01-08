// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'earnings_response_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EarningsResponse _$EarningsResponseFromJson(Map<String, dynamic> json) =>
    EarningsResponse(
      lavadorId: (json['lavador_id'] as num).toInt(),
      earnings: EarningsData.fromJson(json['earnings'] as Map<String, dynamic>),
      paymentHistory: (json['payment_history'] as List<dynamic>)
          .map((e) => PaymentHistoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EarningsResponseToJson(EarningsResponse instance) =>
    <String, dynamic>{
      'lavador_id': instance.lavadorId,
      'earnings': instance.earnings,
      'payment_history': instance.paymentHistory,
    };

EarningsData _$EarningsDataFromJson(Map<String, dynamic> json) => EarningsData(
      today: (json['today'] as num).toDouble(),
      week: (json['week'] as num).toDouble(),
      month: (json['month'] as num).toDouble(),
    );

Map<String, dynamic> _$EarningsDataToJson(EarningsData instance) =>
    <String, dynamic>{
      'today': instance.today,
      'week': instance.week,
      'month': instance.month,
    };

PaymentHistoryItem _$PaymentHistoryItemFromJson(Map<String, dynamic> json) =>
    PaymentHistoryItem(
      date: DateTime.parse(json['date'] as String),
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$PaymentHistoryItemToJson(PaymentHistoryItem instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'amount': instance.amount,
      'status': instance.status,
    };
