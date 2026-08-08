import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:laundary_app/core/utils/logging/logger.dart';

class NotificationService {
  static NotificationService? _instance;
  NotificationService._();
  static NotificationService get instance {
    _instance ??= NotificationService._();
    return _instance!;
  }

  // ─── REST backend ────────────────────────────────────────────────────────────

  final String _backendUrl =
      "https://notification-backend-y9cy.onrender.com/send_notification";

  /// Sends a push notification to the client device via the REST backend.
  ///
  /// [clientId]         — Firestore document ID of the target client.
  /// [notificationType] — e.g. "order_picked", "order_ready", "order_delivered"
  /// [fcmTokens]        — Optional list of active FCM tokens for the client.
  Future<void> sendNotification(
    String? clientId,
    String notificationType, {
    List<String>? fcmTokens,
  }) async {
    if (clientId == null || clientId.isEmpty) return;

    // Early return if client has no active FCM tokens registered
    if (fcmTokens != null && fcmTokens.isEmpty) {
      AppLogger.logInfo(
        "Skipping notification for client $clientId: fcmTokens list is empty.",
      );
      return;
    }

    final url = Uri.parse(_backendUrl);
    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'clientId': clientId,
          'notificationType': notificationType,
        }),
      );

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(res.body);
        AppLogger.logInfo("Notification sent ✓ — ${data['message']}");
      } else {
        AppLogger.logInfo(
          "Notification backend error: ${res.statusCode} — ${res.body}",
        );
      }
    } catch (e) {
      AppLogger.logInfo("Failed to send notification: $e");
    }
  }

  // ─── Foreground / Local notifications ────────────────────────────────────────

  static const _channelId = 'laundry_orders';
  static const _channelName = 'Order Updates';
  static const _channelDesc =
      'Notifications for order status changes (picked, ready, delivered)';

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Call once at app startup (from main.dart → _initServices).
  ///
  /// • Creates the Android notification channel.
  /// • Registers a listener for foreground FCM messages.
  /// • On Android: shows a local notification banner when a message arrives.
  /// • On iOS: the system already shows the banner thanks to
  ///   setForegroundNotificationPresentationOptions set in main.dart.
  Future<void> init() async {
    await _setupLocalNotifications();
    _listenForegroundMessages();
  }

  Future<void> _setupLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(initSettings);

    // Create the Android notification channel (no-op on iOS)
    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDesc,
        importance: Importance.high,
      );
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);
    }
  }

  void _listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      AppLogger.logInfo(
        "Foreground FCM message received: ${message.notification?.title}",
      );

      final notification = message.notification;
      if (notification == null) return;

      final title = notification.title ?? 'Maa Laundry';
      final body = notification.body ?? '';

      if (Platform.isAndroid) {
        // Show a local notification banner on Android
        await _localNotifications.show(
          // Use hashCode of messageId to get a unique int ID
          message.messageId?.hashCode ?? DateTime.now().millisecondsSinceEpoch,
          title,
          body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              _channelId,
              _channelName,
              channelDescription: _channelDesc,
              importance: Importance.high,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      } else {
        // On iOS the system banner is already shown; show an in-app snackbar
        // as a supplementary visual cue.
        Get.snackbar(
          title,
          body,
          duration: const Duration(seconds: 4),
          snackPosition: SnackPosition.TOP,
        );
      }
    });
  }
}
