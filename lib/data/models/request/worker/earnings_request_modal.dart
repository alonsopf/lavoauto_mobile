import 'package:json_annotation/json_annotation.dart';

part 'earnings_request_modal.g.dart';

@JsonSerializable()
class EarningsRequest {
  /// User authentication token
  final String token;

  EarningsRequest({required this.token});

  factory EarningsRequest.fromJson(Map<String, dynamic> json) =>
      _$EarningsRequestFromJson(json);

  /// Custom `toJson` method to include the static `path` and nest the model under `body`
  Map<String, dynamic> toJson() => {
        "path": "/lavador-earnings", // Static path
        "body": _$EarningsRequestToJson(this), // Serialize the model under "body"
      };
}
