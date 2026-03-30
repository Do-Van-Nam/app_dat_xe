import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'navigation_handler.dart';

class LocalNotificationService {
  LocalNotificationService._();

  static final instance = LocalNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// INIT
  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();

    const settings = InitializationSettings(android: android, iOS: ios);

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null) {
          try {
            final data = jsonDecode(payload);
            if (data is Map<String, dynamic>) {
              NavigationHandler.instance.handleFcmData(data);
            }
          } catch (_) {
            // Ignore malformed payload
          }
        }
      },
    );
  }

  /// SHOW FROM FCM DATA
  Future<void> showFromFCM(RemoteMessage message) async {
    final data = message.data;

    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      data['title'],
      data['body'],
      details,
      // store entire data payload so we can navigate when user taps
      payload: jsonEncode(data),
    );
  }
}
