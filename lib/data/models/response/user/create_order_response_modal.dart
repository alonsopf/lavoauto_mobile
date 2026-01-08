import 'package:json_annotation/json_annotation.dart';

part 'create_order_response_modal.g.dart';

@JsonSerializable()
class CreateOrderResponse {
  /// Response message
  final String? message;

  /// Created order ID
  @JsonKey(name: 'orden_id')
  final int? ordenId;

  CreateOrderResponse({
     this.message,
     this.ordenId,
  });

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderResponseToJson(this);
}