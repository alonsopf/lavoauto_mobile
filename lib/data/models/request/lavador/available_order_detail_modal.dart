import 'package:json_annotation/json_annotation.dart';

part 'available_order_detail_modal.g.dart';

@JsonSerializable()
class AvailableOrderDetailRequest {
  /// User authentication token
  final String token;

  /// Order ID
  @JsonKey(name: 'order_id')
  final int orderId;

  AvailableOrderDetailRequest({
    required this.token,
    required this.orderId,
  });

  factory AvailableOrderDetailRequest.fromJson(Map<String, dynamic> json) =>
      _$AvailableOrderDetailRequestFromJson(json);

  Map<String, dynamic> toJson() => {
        "path": "/get-available-order-details", // Static path for available orders
        "body": _$AvailableOrderDetailRequestToJson(this), // Serialize the model under "body"
      };
}