import 'package:json_annotation/json_annotation.dart';

part 'lavador_order_detail_modal.g.dart';

@JsonSerializable()
class LavadorOrderDetailRequest {
  /// User authentication token
  final String token;

  /// Order ID
  @JsonKey(name: 'order_id')
  final int orderId;

  LavadorOrderDetailRequest({
    required this.token,
    required this.orderId,
  });

  factory LavadorOrderDetailRequest.fromJson(Map<String, dynamic> json) =>
      _$LavadorOrderDetailRequestFromJson(json);

  Map<String, dynamic> toJson() => {
        "path": "/get-lavador-order-details", // Static path
        "body": _$LavadorOrderDetailRequestToJson(this), // Serialize the model under "body"
      };
}