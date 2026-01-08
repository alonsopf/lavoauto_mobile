import 'package:json_annotation/json_annotation.dart';

part 'registeration_response_modal.g.dart';

@JsonSerializable()
class WorkerRegistrationResponse {
  /// Registration status message
  final String message;

  /// Registered lavador ID
  @JsonKey(name: 'lavador_id')
  final int lavadorId;

  WorkerRegistrationResponse({
    required this.message,
    required this.lavadorId,
  });

  factory WorkerRegistrationResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkerRegistrationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WorkerRegistrationResponseToJson(this);
}