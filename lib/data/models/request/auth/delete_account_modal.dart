import 'package:json_annotation/json_annotation.dart';

part 'delete_account_modal.g.dart';

@JsonSerializable()
class DeleteAccountRequest {
  final String token;

  DeleteAccountRequest({required this.token});

  factory DeleteAccountRequest.fromJson(Map<String, dynamic> json) =>
      _$DeleteAccountRequestFromJson(json);

  Map<String, dynamic> toJson() => {
        "path": "/delete-account",
        "body": _$DeleteAccountRequestToJson(this),
      };
}

@JsonSerializable()
class DeleteAccountBody {
  final String token;

  DeleteAccountBody({required this.token});

  factory DeleteAccountBody.fromJson(Map<String, dynamic> json) =>
      _$DeleteAccountBodyFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteAccountBodyToJson(this);
}