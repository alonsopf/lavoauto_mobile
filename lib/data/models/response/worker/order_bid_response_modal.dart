import 'package:json_annotation/json_annotation.dart';

part 'order_bid_response_modal.g.dart';

@JsonSerializable()
class OrderBidResponse {
  /// Response message
  final String? message;

  /// Created bid ID
  @JsonKey(name: 'puja_id')
  final int? pujaId;

  OrderBidResponse({
     this.message,
     this.pujaId,
  });

  factory OrderBidResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderBidResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderBidResponseToJson(this);
}