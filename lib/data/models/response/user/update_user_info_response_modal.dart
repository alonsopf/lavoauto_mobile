import 'package:json_annotation/json_annotation.dart';

part 'update_user_info_response_modal.g.dart';

@JsonSerializable()
class UpdateUserInfoResponse {
  /// Success message
  final String message;

  UpdateUserInfoResponse({
    required this.message,
  });

  factory UpdateUserInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserInfoResponseToJson(this);
} 