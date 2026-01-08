import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lavoauto/data/repositories/chat_repository.dart';

class PushNotificationService {
  static final PushNotificationService _instance = PushNotificationService._internal();
  late FirebaseMessaging _firebaseMessaging;
  final Map<String, Function> _messageHandlers = {};

  factory PushNotificationService() {
    return _instance;
  }

  PushNotificationService._internal() {
    _firebaseMessaging = FirebaseMessaging.instance;
  }

  /// Initialize push notifications
  Future<void> initialize({
    required String token,
    required Function(RemoteMessage) onMessageReceived,
    required Function(RemoteMessage) onMessageOpenedFromTerminated,
    required Function(RemoteMessage) onMessageOpenedFromBackground,
  }) async {
    // Request permission (iOS only, Android handles this differently)
    if (Platform.isIOS) {
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        print('User denied notification permissions');
        return;
      }
    }

    // Get device token
    String? deviceToken = await _firebaseMessaging.getToken();
    if (deviceToken != null) {
      print('Device Token: $deviceToken');
      await _registerDeviceToken(token, deviceToken);
    }

    // Listen for token refreshes
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      print('Token refreshed: $newToken');
      await _registerDeviceToken(token, newToken);
    });

    // Handle message when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message received: ${message.notification?.title}');
      onMessageReceived(message);
    });

    // Handle notification when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened from background: ${message.data}');
      onMessageOpenedFromBackground(message);
    });

    // Handle notification when app is terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print('App opened from terminated: ${initialMessage.data}');
      onMessageOpenedFromTerminated(initialMessage);
    }
  }

  /// Register device token to backend
  Future<void> _registerDeviceToken(String token, String deviceToken) async {
    try {
      final chatRepository = ChatRepository(token: token);
      final platform = Platform.isIOS ? 'ios' : 'android';

      await chatRepository.registerDeviceToken(deviceToken, platform);
      print('Device token registered successfully');
    } catch (e) {
      print('Error registering device token: $e');
    }
  }

  /// Register a message handler for a specific type
  void registerMessageHandler(String type, Function handler) {
    _messageHandlers[type] = handler;
  }

  /// Get message handler
  Function? getMessageHandler(String type) {
    return _messageHandlers[type];
  }

  /// Handle remote message (parse and route to appropriate handler)
  void handleRemoteMessage(RemoteMessage message) {
    final data = message.data;
    final type = data['type'] ?? 'chat';

    final handler = getMessageHandler(type);
    if (handler != null) {
      handler(message);
    }
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    final settings = await _firebaseMessaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  /// Request notification permissions
  Future<bool> requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  /// Get notification settings
  Future<NotificationSettings> getNotificationSettings() async {
    return await _firebaseMessaging.getNotificationSettings();
  }

  /// Get device FCM token
  Future<String?> getDeviceToken() async {
    return await _firebaseMessaging.getToken();
  }

  /// Simple initialization for token registration only (used in auth flow)
  Future<void> initializeForAuth(String authToken) async {
    // Request permission (iOS only)
    if (Platform.isIOS) {
      print('🍎 Requesting iOS notification permissions...');
      await requestNotificationPermission();

      // Wait a bit for iOS to receive APNs token
      print('⏳ Waiting for APNs token...');
      await Future.delayed(Duration(seconds: 2));
    }

    // Try to get device token with retry
    String? deviceToken;
    int retries = 3;

    for (int i = 0; i < retries; i++) {
      try {
        print('🔍 Attempt ${i + 1}/$retries to get device token...');
        deviceToken = await getDeviceToken();

        if (deviceToken != null && deviceToken.isNotEmpty) {
          print('✅ Device Token obtained: $deviceToken');
          break;
        }

        if (i < retries - 1) {
          print('⏳ Token not available yet, waiting 3 seconds...');
          await Future.delayed(Duration(seconds: 3));
        }
      } catch (e) {
        print('⚠️ Error getting token (attempt ${i + 1}/$retries): $e');
        if (i < retries - 1) {
          await Future.delayed(Duration(seconds: 3));
        }
      }
    }

    if (deviceToken != null && deviceToken.isNotEmpty) {
      await _registerDeviceToken(authToken, deviceToken);
    } else {
      print('❌ Could not obtain device token after $retries attempts');
      print('💡 This might be normal in iOS simulator. Try on a real device.');
    }

    // Listen for token refreshes
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      print('🔄 Token refreshed: $newToken');
      await _registerDeviceToken(authToken, newToken);
    });
  }
}

/// Background message handler (must be a top-level function)
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message received: ${message.notification?.title}');
  // Handle background message here
}
