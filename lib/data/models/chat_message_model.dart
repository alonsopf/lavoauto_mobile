import 'package:json_annotation/json_annotation.dart';

part 'chat_message_model.g.dart';

@JsonSerializable()
class ChatMessage {
  @JsonKey(name: 'message_id')
  final int messageId;

  @JsonKey(name: 'chat_id')
  final int chatId;

  @JsonKey(name: 'sender_id')
  final int senderId;

  @JsonKey(name: 'sender_type')
  final String senderType; // "client" or "lavador"

  @JsonKey(name: 'message_text')
  final String messageText;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'is_read')
  final bool isRead;

  @JsonKey(name: 'read_at')
  final String? readAt;

  ChatMessage({
    required this.messageId,
    required this.chatId,
    required this.senderId,
    required this.senderType,
    required this.messageText,
    required this.createdAt,
    required this.isRead,
    this.readAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

  DateTime get createdAtDateTime => DateTime.parse(createdAt);

  bool get isCurrentUserSender => senderType == 'client' || senderType == 'lavador';
}

@JsonSerializable()
class ChatMessageResponse {
  @JsonKey(name: 'messages')
  final List<ChatMessage> messages;

  @JsonKey(name: 'total')
  final int total;

  ChatMessageResponse({
    required this.messages,
    required this.total,
  });

  factory ChatMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageResponseToJson(this);
}

@JsonSerializable()
class SendMessageRequest {
  @JsonKey(name: 'message_text')
  final String messageText;

  SendMessageRequest({
    required this.messageText,
  });

  factory SendMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$SendMessageRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SendMessageRequestToJson(this);
}

@JsonSerializable()
class SendMessageResponse {
  @JsonKey(name: 'message_id')
  final int messageId;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'is_read')
  final bool isRead;

  SendMessageResponse({
    required this.messageId,
    required this.createdAt,
    required this.isRead,
  });

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$SendMessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendMessageResponseToJson(this);
}

@JsonSerializable()
class MarkMessagesReadRequest {
  @JsonKey(name: 'message_ids')
  final List<int> messageIds;

  MarkMessagesReadRequest({
    required this.messageIds,
  });

  factory MarkMessagesReadRequest.fromJson(Map<String, dynamic> json) =>
      _$MarkMessagesReadRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MarkMessagesReadRequestToJson(this);
}

@JsonSerializable()
class MarkMessagesReadResponse {
  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'updated')
  final int updated;

  MarkMessagesReadResponse({
    required this.success,
    required this.updated,
  });

  factory MarkMessagesReadResponse.fromJson(Map<String, dynamic> json) =>
      _$MarkMessagesReadResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MarkMessagesReadResponseToJson(this);
}
