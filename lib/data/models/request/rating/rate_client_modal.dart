import 'package:json_annotation/json_annotation.dart';

part 'rate_client_modal.g.dart';

@JsonSerializable()
class RateClientRequest {
  /// User authentication token
  final String token;

  /// Order ID
  @JsonKey(name: 'order_id')
  final int orderId;

  /// Rating from 1.0 to 5.0
  final double rating;

  /// Optional comments
  final String comentarios;

  RateClientRequest({
    required this.token,
    required this.orderId,
    required this.rating,
    required this.comentarios,
  });

  factory RateClientRequest.fromJson(Map<String, dynamic> json) =>
      _$RateClientRequestFromJson(json);

  /// Custom `toJson` method to include the static `path` and nest the model under `body`
  Map<String, dynamic> toJson() => {
        "path": "/rate-client", // Static path
        "body": _$RateClientRequestToJson(this), // Serialize the model under "body"
      };
} 