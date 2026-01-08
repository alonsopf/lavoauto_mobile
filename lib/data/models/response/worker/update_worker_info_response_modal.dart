import 'package:json_annotation/json_annotation.dart';

part 'update_worker_info_response_modal.g.dart';

@JsonSerializable()
class UpdateWorkerInfoResponse {
  /// Success message
  final String message;

  UpdateWorkerInfoResponse({
    required this.message,
  });

  factory UpdateWorkerInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateWorkerInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateWorkerInfoResponseToJson(this);
} 