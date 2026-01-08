import 'package:json_annotation/json_annotation.dart';

part 'my_work_request_modal.g.dart';

@JsonSerializable()
class MyWorkRequest {
  /// User authentication token
  final String token;

  MyWorkRequest({required this.token});

  factory MyWorkRequest.fromJson(Map<String, dynamic> json) =>
      _$MyWorkRequestFromJson(json);

  /// Custom `toJson` method to include the static `path` and nest the model under `body`
  Map<String, dynamic> toJson() => {
        "path": "/my-work", // Static path
        "body": _$MyWorkRequestToJson(this), // Serialize the model under "body"
      };
} 