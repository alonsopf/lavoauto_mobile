import 'package:json_annotation/json_annotation.dart';

part 'collect_order_modal.g.dart';

@JsonSerializable()
class CollectOrderRequest {
  /// User authentication token
  final String token;

  /// Order ID
  @JsonKey(name: 'orden_id')
  final int ordenId;

  /// Final weight in kilograms
  @JsonKey(name: 'peso_final_kg')
  final double pesoFinalKg;

  CollectOrderRequest({
    required this.token,
    required this.ordenId,
    required this.pesoFinalKg,
  });

  factory CollectOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CollectOrderRequestFromJson(json);

  /// Custom `toJson` method to include the static `path` and nest the model under `body`
  Map<String, dynamic> toJson() => {
        "path": "/lavador-collect-lavado", // Static path
        "body": _$CollectOrderRequestToJson(this), // Serialize the model under "body"
      };
}