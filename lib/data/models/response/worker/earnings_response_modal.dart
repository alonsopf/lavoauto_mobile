import 'package:json_annotation/json_annotation.dart';

part 'earnings_response_modal.g.dart';

@JsonSerializable()
class EarningsResponse {
  /// Lavador (worker) ID
  @JsonKey(name: 'lavador_id')
  final int lavadorId;

  /// Earnings breakdown
  final EarningsData earnings;

  /// Payment history list
  @JsonKey(name: 'payment_history')
  final List<PaymentHistoryItem> paymentHistory;

  EarningsResponse({
    required this.lavadorId,
    required this.earnings,
    required this.paymentHistory,
  });

  factory EarningsResponse.fromJson(Map<String, dynamic> json) =>
      _$EarningsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EarningsResponseToJson(this);
}

@JsonSerializable()
class EarningsData {
  /// Today's earnings
  final double today;

  /// This week's earnings
  final double week;

  /// This month's earnings
  final double month;

  EarningsData({
    required this.today,
    required this.week,
    required this.month,
  });

  factory EarningsData.fromJson(Map<String, dynamic> json) =>
      _$EarningsDataFromJson(json);

  Map<String, dynamic> toJson() => _$EarningsDataToJson(this);
}

@JsonSerializable()
class PaymentHistoryItem {
  /// Payment date
  final DateTime date;

  /// Payment amount (after commission)
  final double amount;

  /// Payment status
  final String status;

  PaymentHistoryItem({
    required this.date,
    required this.amount,
    required this.status,
  });

  factory PaymentHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$PaymentHistoryItemFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentHistoryItemToJson(this);
}
