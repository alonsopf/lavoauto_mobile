import 'package:json_annotation/json_annotation.dart';

part 'deliver_order_response_modal.g.dart';

@JsonSerializable()
class DeliverOrderResponse {
  /// Lavador (worker) ID
  @JsonKey(name: 'lavador_id')
  final int lavadorId;

  /// Response message
  final String message;

  /// Order ID
  @JsonKey(name: 'orden_id')
  final int ordenId;

  DeliverOrderResponse({
    required this.lavadorId,
    required this.message,
    required this.ordenId,
  });

  factory DeliverOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$DeliverOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeliverOrderResponseToJson(this);
}
