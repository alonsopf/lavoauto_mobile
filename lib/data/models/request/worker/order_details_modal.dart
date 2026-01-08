import 'package:json_annotation/json_annotation.dart';

part 'order_details_modal.g.dart';

@JsonSerializable()
class OrderDetailsRequest {
  /// User authentication token
  final String token;

  /// Order ID
  @JsonKey(name: 'order_id')
  final int orderId;

  OrderDetailsRequest({
    required this.token,
    required this.orderId,
  });

  factory OrderDetailsRequest.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsRequestFromJson(json);

  Map<String, dynamic> toJson() => {
        "path": "/get-lavador-order-details", // Static path
        "body": _$OrderDetailsRequestToJson(this), // Serialize the model under "body"
      };
}