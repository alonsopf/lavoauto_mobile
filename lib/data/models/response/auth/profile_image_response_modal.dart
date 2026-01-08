import 'package:json_annotation/json_annotation.dart';

part 'profile_image_response_modal.g.dart';

@JsonSerializable()
class ProfileImageResponse {
  /// Uploaded profile image URL
  @JsonKey(name: 'image_url')
  final String? imageUrl;

  ProfileImageResponse({ this.imageUrl});

  factory ProfileImageResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileImageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileImageResponseToJson(this);
}