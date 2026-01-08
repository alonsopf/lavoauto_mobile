import 'package:json_annotation/json_annotation.dart';

part 'rate_service_modal.g.dart';

@JsonSerializable()
class RateServiceRequest {
  /// User authentication token
  final String token;

  /// Order ID
  @JsonKey(name: 'order_id')
  final int orderId;

  /// Rating from 1.0 to 5.0
  final double rating;

  /// Optional comments
  final String comentarios;

  RateServiceRequest({
    required this.token,
    required this.orderId,
    required this.rating,
    required this.comentarios,
  });

  factory RateServiceRequest.fromJson(Map<String, dynamic> json) =>
      _$RateServiceRequestFromJson(json);

  /// Custom `toJson` method to include the static `path` and nest the model under `body`
  Map<String, dynamic> toJson() => {
        "path": "/rate-service", // Static path
        "body": _$RateServiceRequestToJson(this), // Serialize the model under "body"
      };
} 