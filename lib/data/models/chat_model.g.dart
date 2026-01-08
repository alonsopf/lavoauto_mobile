// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      chatId: (json['chat_id'] as num).toInt(),
      orderId: (json['order_id'] as num).toInt(),
      hashId: json['hash_id'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'chat_id': instance.chatId,
      'order_id': instance.orderId,
      'hash_id': instance.hashId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

GetChatHashResponse _$GetChatHashResponseFromJson(Map<String, dynamic> json) =>
    GetChatHashResponse(
      hashId: json['hash_id'] as String,
      orderId: (json['order_id'] as num).toInt(),
    );

Map<String, dynamic> _$GetChatHashResponseToJson(
        GetChatHashResponse instance) =>
    <String, dynamic>{
      'hash_id': instance.hashId,
      'order_id': instance.orderId,
    };
