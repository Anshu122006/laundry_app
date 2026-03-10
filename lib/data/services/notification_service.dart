import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:laundary_app/core/utils/logging/logger.dart';

class NotificationService {
  static NotificationService? _instance;
  NotificationService._();
  static NotificationService get instance {
    _instance ??= NotificationService._();
    return _instance!;
  }

  String backendUrl =
      "https://notification-backend-y9cy.onrender.com/send_notification";

  Future<void> sendNotification(
    String? clientId,
    String notificationType,
  ) async {
    if (clientId == null) return;
    final url = Uri.parse(backendUrl);
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
        Map<String, dynamic> data = jsonDecode(res.body);
        AppLogger.logInfo("Success: ${data['message']}");
      } else {
        AppLogger.logInfo("Server Error: ${res.statusCode} - ${res.body}");
      }
    } catch (e) {
      AppLogger.logInfo("Failed to connect: $e");
    }
  }
}
