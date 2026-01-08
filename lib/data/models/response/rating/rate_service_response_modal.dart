import 'package:json_annotation/json_annotation.dart';

part 'rate_service_response_modal.g.dart';

@JsonSerializable()
class RateServiceResponse {
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

  /// Lavador (service provider) ID
  @JsonKey(name: 'lavador_id')
  final int lavadorId;

  RateServiceResponse({
    required this.message,
    required this.ratingId,
    required this.orderId,
    required this.rating,
    required this.lavadorId,
  });

  factory RateServiceResponse.fromJson(Map<String, dynamic> json) =>
      _$RateServiceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RateServiceResponseToJson(this);
} 