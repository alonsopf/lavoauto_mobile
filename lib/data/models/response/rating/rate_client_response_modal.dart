import 'package:json_annotation/json_annotation.dart';

part 'rate_client_response_modal.g.dart';

@JsonSerializable()
class RateClientResponse {
  /// Response message
  final String message;

  /// Rating ID
  @JsonKey(name: 'rating_id')
  final int ratingId;

  /// Order ID
  @JsonKey(name: 'order_id')
  final int orderId;

  /// Rating value
  final double rating;

  /// Client ID
  @JsonKey(name: 'client_id')
  final int clientId;

  RateClientResponse({
    required this.message,
    required this.ratingId,
    required this.orderId,
    required this.rating,
    required this.clientId,
  });

  factory RateClientResponse.fromJson(Map<String, dynamic> json) =>
      _$RateClientResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RateClientResponseToJson(this);
} 