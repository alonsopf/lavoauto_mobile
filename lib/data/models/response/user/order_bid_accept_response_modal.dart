import 'package:json_annotation/json_annotation.dart';

part 'order_bid_accept_response_modal.g.dart';

@JsonSerializable()
class OrderBidAcceptResponse {
  /// Lavador (worker) ID
  @JsonKey(name: 'lavador_id')
  final int lavadorId;

  /// Response message
  final String message;

  /// Order ID
  @JsonKey(name: 'orden_id')
  final int ordenId;

  /// Bid ID
  @JsonKey(name: 'puja_id')
  final int pujaId;

  /// Whether other bids were rejected
  @JsonKey(name: 'pujas_rejected')
  final bool pujasRejected;

  OrderBidAcceptResponse({
    required this.lavadorId,
    required this.message,
    required this.ordenId,
    required this.pujaId,
    required this.pujasRejected,
  });

  factory OrderBidAcceptResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderBidAcceptResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderBidAcceptResponseToJson(this);
}