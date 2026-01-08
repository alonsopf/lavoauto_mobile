import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lavoauto/core/config/app_config.dart';
import 'package:lavoauto/data/models/chat_message_model.dart';
import 'package:lavoauto/data/models/chat_model.dart';
import 'package:lavoauto/data/models/device_token_model.dart';

class ChatRepository {
  final String baseUrl = AppConfig.baseUrl;
  final String token;

  ChatRepository({required this.token});

  /// Get or create chat hash for an order
  Future<GetChatHashResponse> getOrCreateChatHash(int orderId) async {
    final url = Uri.parse('$baseUrl/order/$orderId/chat-hash');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return GetChatHashResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else if (response.statusCode == 400) {
      throw Exception('Invalid request');
    } else if (response.statusCode == 403) {
      throw Exception('Not authorized to access this order');
    } else {
      throw Exception('Failed to get chat hash: ${response.statusCode}');
    }
  }

  /// Send a message in a chat
  Future<SendMessageResponse> sendMessage(
    String hashId,
    String messageText,
  ) async {
    final url = Uri.parse('$baseUrl/chat/$hashId/send');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: utf8.encode(jsonEncode({
        'message_text': messageText,
      })),
    );

    if (response.statusCode == 200) {
      return SendMessageResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else if (response.statusCode == 400) {
      throw Exception('Invalid message');
    } else if (response.statusCode == 403) {
      throw Exception('Not authorized to send messages');
    } else {
      throw Exception('Failed to send message: ${response.statusCode}');
    }
  }

  /// Get messages from a chat
  Future<ChatMessageResponse> getMessages(
    String hashId, {
    int limit = 50,
    int offset = 0,
  }) async {
    final url = Uri.parse(
      '$baseUrl/chat/$hashId/messages?limit=$limit&offset=$offset',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return ChatMessageResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else if (response.statusCode == 404) {
      throw Exception('Chat not found');
    } else {
      throw Exception('Failed to get messages: ${response.statusCode}');
    }
  }

  /// Mark messages as read
  Future<MarkMessagesReadResponse> markMessagesAsRead(
    String hashId,
    List<int> messageIds,
  ) async {
    final url = Uri.parse('$baseUrl/chat/$hashId/read');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: utf8.encode(jsonEncode({
        'message_ids': messageIds,
      })),
    );

    if (response.statusCode == 200) {
      return MarkMessagesReadResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else if (response.statusCode == 400) {
      throw Exception('Invalid request');
    } else {
      throw Exception('Failed to mark messages as read: ${response.statusCode}');
    }
  }

  /// Register device token for push notifications
  Future<RegisterDeviceTokenResponse> registerDeviceToken(
    String deviceToken,
    String platform,
  ) async {
    final url = Uri.parse('$baseUrl/register-device-token');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'device_token': deviceToken,
        'platform': platform,
      }),
    );

    if (response.statusCode == 200) {
      return RegisterDeviceTokenResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to register device token: ${response.statusCode}');
    }
  }

  /// Update notification settings
  Future<UpdateNotificationSettingsResponse> updateNotificationSettings(
    bool enabled,
  ) async {
    final url = Uri.parse('$baseUrl/notification-settings');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'notifications_enabled': enabled,
      }),
    );

    if (response.statusCode == 200) {
      return UpdateNotificationSettingsResponse.fromJson(
        jsonDecode(response.body),
      );
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception(
        'Failed to update notification settings: ${response.statusCode}',
      );
    }
  }
}
