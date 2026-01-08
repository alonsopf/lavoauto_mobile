import 'package:json_annotation/json_annotation.dart';

part 'deliver_order_modal.g.dart';

@JsonSerializable()
class DeliverOrderRequest {
  /// User authentication token
  final String token;

  /// Order ID
  @JsonKey(name: 'orden_id')
  final int ordenId;

  /// Delivery photo S3 URL - Optional since photo delivery is no longer used
  @JsonKey(name: 'foto_s3_entrega')
  final String? fotoS3Entrega;

  DeliverOrderRequest({
    required this.token,
    required this.ordenId,
    this.fotoS3Entrega, // Now optional
  });

  factory DeliverOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$DeliverOrderRequestFromJson(json);

  /// Custom `toJson` method to include the static `path` and nest the model under `body`
  Map<String, dynamic> toJson() => {
        "path": "/deliver-lavado", // Static path
        "body": _$DeliverOrderRequestToJson(this), // Serialize the model under "body"
      };
}