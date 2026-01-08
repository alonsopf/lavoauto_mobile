import 'package:json_annotation/json_annotation.dart';

part 'availableOrdersRequest_modal.g.dart';

@JsonSerializable()
class ListAvailableOrdersRequest {
  /// User authentication token
  final String token;

  ListAvailableOrdersRequest({required this.token});

  factory ListAvailableOrdersRequest.fromJson(Map<String, dynamic> json) =>
      _$ListAvailableOrdersRequestFromJson(json);

    /// Custom `toJson` method to include the static `path` and nest the model under `body`
  Map<String, dynamic> toJson() => {
        "path": "/list-available-orders", // Static path
        "body": _$ListAvailableOrdersRequestToJson(this), // Serialize the model under "body"
      };
}
