import 'package:json_annotation/json_annotation.dart';

part 'order_bids_modal.g.dart';

@JsonSerializable()
class ListOrderBidsRequest {
  /// User authentication token
  final String token;

  /// Order ID
  @JsonKey(name: 'orden_id')
  final int ordenId;

  ListOrderBidsRequest({
    required this.token,
    required this.ordenId,
  });

  factory ListOrderBidsRequest.fromJson(Map<String, dynamic> json) =>
      _$ListOrderBidsRequestFromJson(json);


    Map<String, dynamic> toJson() => {
        "path": "/list-pujas-for-order", // Static path
        "body": _$ListOrderBidsRequestToJson(this), // Serialize the model under "body"
      };
}