import 'package:json_annotation/json_annotation.dart';

part 'orders_modal.g.dart';

@JsonSerializable()
class GetOrderRequests {
  /// User authentication token
  final String token;

  GetOrderRequests({required this.token});

  factory GetOrderRequests.fromJson(Map<String, dynamic> json) =>
      _$GetOrderRequestsFromJson(json);

   Map<String, dynamic> toJson() => {
        "path": "/get-order-requests", // Static path
        "body": _$GetOrderRequestsToJson(this), // Serialize the model under "body"
      };
}