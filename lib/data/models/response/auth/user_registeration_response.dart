import 'package:json_annotation/json_annotation.dart';

part 'user_registeration_response.g.dart';

@JsonSerializable()
class UserRegistrationResponse {
  /// Registration status message
  final String? message;

  /// Registered client ID
  @JsonKey(name: 'cliente_id')
  final int? clienteId;

  /// Registered worker ID
  @JsonKey(name: 'lavador_id')
  final int? lavadorId;
  UserRegistrationResponse({
    this.message,
    this.clienteId,
    this.lavadorId,
  });

  factory UserRegistrationResponse.fromJson(Map<String, dynamic> json) =>
      _$UserRegistrationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserRegistrationResponseToJson(this);
}
