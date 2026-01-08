// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      messageId: (json['message_id'] as num).toInt(),
      chatId: (json['chat_id'] as num).toInt(),
      senderId: (json['sender_id'] as num).toInt(),
      senderType: json['sender_type'] as String,
      messageText: json['message_text'] as String,
      createdAt: json['created_at'] as String,
      isRead: json['is_read'] as bool,
      readAt: json['read_at'] as String?,
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'message_id': instance.messageId,
      'chat_id': instance.chatId,
      'sender_id': instance.senderId,
      'sender_type': instance.senderType,
      'message_text': instance.messageText,
      'created_at': instance.createdAt,
      'is_read': instance.isRead,
      'read_at': instance.readAt,
    };

ChatMessageResponse _$ChatMessageResponseFromJson(Map<String, dynamic> json) =>
    ChatMessageResponse(
      messages: (json['messages'] as List<dynamic>)
          .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$ChatMessageResponseToJson(
        ChatMessageResponse instance) =>
    <String, dynamic>{
      'messages': instance.messages,
      'total': instance.total,
    };

SendMessageRequest _$SendMessageRequestFromJson(Map<String, dynamic> json) =>
    SendMessageRequest(
      messageText: json['message_text'] as String,
    );

Map<String, dynamic> _$SendMessageRequestToJson(SendMessageRequest instance) =>
    <String, dynamic>{
      'message_text': instance.messageText,
    };

SendMessageResponse _$SendMessageResponseFromJson(Map<String, dynamic> json) =>
    SendMessageResponse(
      messageId: (json['message_id'] as num).toInt(),
      createdAt: json['created_at'] as String,
      isRead: json['is_read'] as bool,
    );

Map<String, dynamic> _$SendMessageResponseToJson(
        SendMessageResponse instance) =>
    <String, dynamic>{
      'message_id': instance.messageId,
      'created_at': instance.createdAt,
      'is_read': instance.isRead,
    };

MarkMessagesReadRequest _$MarkMessagesReadRequestFromJson(
        Map<String, dynamic> json) =>
    MarkMessagesReadRequest(
      messageIds: (json['message_ids'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$MarkMessagesReadRequestToJson(
        MarkMessagesReadRequest instance) =>
    <String, dynamic>{
      'message_ids': instance.messageIds,
    };

MarkMessagesReadResponse _$MarkMessagesReadResponseFromJson(
        Map<String, dynamic> json) =>
    MarkMessagesReadResponse(
      success: json['success'] as bool,
      updated: (json['updated'] as num).toInt(),
    );

Map<String, dynamic> _$MarkMessagesReadResponseToJson(
        MarkMessagesReadResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'updated': instance.updated,
    };
