import 'package:json_annotation/json_annotation.dart';

part 'delete_account_response_modal.g.dart';

@JsonSerializable()
class DeleteAccountResponse {
  final String? message;
  @JsonKey(name: 'deleted_user')
  final String? deletedUser;

  DeleteAccountResponse({this.message, this.deletedUser});

  factory DeleteAccountResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteAccountResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteAccountResponseToJson(this);
}