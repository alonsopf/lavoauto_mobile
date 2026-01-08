import 'package:json_annotation/json_annotation.dart';

part 'chat_model.g.dart';

@JsonSerializable()
class Chat {
  @JsonKey(name: 'chat_id')
  final int chatId;

  @JsonKey(name: 'order_id')
  final int orderId;

  @JsonKey(name: 'hash_id')
  final String hashId;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  Chat({
    required this.chatId,
    required this.orderId,
    required this.hashId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);

  DateTime get createdAtDateTime => DateTime.parse(createdAt);
  DateTime get updatedAtDateTime => DateTime.parse(updatedAt);
}

@JsonSerializable()
class GetChatHashResponse {
  @JsonKey(name: 'hash_id')
  final String hashId;

  @JsonKey(name: 'order_id')
  final int orderId;

  GetChatHashResponse({
    required this.hashId,
    required this.orderId,
  });

  factory GetChatHashResponse.fromJson(Map<String, dynamic> json) =>
      _$GetChatHashResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetChatHashResponseToJson(this);
}
