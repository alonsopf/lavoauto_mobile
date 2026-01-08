import 'package:json_annotation/json_annotation.dart';

part 'accept_bid_order_modal.g.dart';

@JsonSerializable()
class AcceptBidOrderRequest {
  /// User authentication token
  final String token;

  /// Order ID
  @JsonKey(name: 'orden_id')
  final int ordenId;

  /// Bid ID
  @JsonKey(name: 'puja_id')
  final int pujaId;

  AcceptBidOrderRequest({
    required this.token,
    required this.ordenId,
    required this.pujaId,
  });

  factory AcceptBidOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$AcceptBidOrderRequestFromJson(json);

  Map<String, dynamic> toJson() => {
        "path": "/accept-puja", // Static path
        "body": _$AcceptBidOrderRequestToJson(
            this), // Serialize the model under "body"
      };
}