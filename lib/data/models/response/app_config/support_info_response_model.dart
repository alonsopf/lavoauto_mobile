import 'package:json_annotation/json_annotation.dart';

part 'support_info_response_model.g.dart';

@JsonSerializable()
class SupportInfoResponse {
  @JsonKey(name: 'support_whatsapp_number')
  final String supportWhatsAppNumber;

  const SupportInfoResponse({
    required this.supportWhatsAppNumber,
  });

  factory SupportInfoResponse.fromJson(Map<String, dynamic> json) => _$SupportInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SupportInfoResponseToJson(this);
}