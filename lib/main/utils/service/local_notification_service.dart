import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'navigation_handler.dart';

class LocalNotificationService {
  LocalNotificationService._();

  static final instance = LocalNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Khởi tạo thông báo cục bộ
  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(android: android, iOS: ios);

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  /// Xử lý khi người dùng nhấn vào thông báo
  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      try {
        final data = jsonDecode(payload) as Map<String, dynamic>;
        NavigationHandler.instance.handleFcmData(data);
      } catch (e) {
        print('Payload decode error: $e');
      }
    }
  }

  /// ==================== HÀM MỚI: GỬI THÔNG BÁO TỪ BẤT KỲ ĐÂU ====================
  /// Dùng để gửi thông báo cục bộ từ bất kỳ màn hình nào trong app
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload, // Dữ liệu muốn truyền khi nhấn vào thông báo
    Importance importance = Importance.max,
    Priority priority = Priority.high,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'general_channel', // channel id
      'Thông báo chung', // channel name
      importance: importance,
      priority: priority,
      playSound: true,
      enableVibration: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(),
    );

    // Tạo id unique dựa trên thời gian
    final int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await _plugin.show(
      notificationId,
      title,
      body,
      details,
      payload: payload, // Có thể là JSON string hoặc String đơn giản
    );
  }

  /// Hàm tiện ích: Gửi thông báo với payload là Map (dễ điều hướng sau này)
  Future<void> showNotificationWithData({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    final payload = data != null ? jsonEncode(data) : null;

    await showNotification(
      title: title,
      body: body,
      payload: payload,
    );
  }

  /// ==================== HÀM CŨ (GIỮ LẠI) ====================
  Future<void> showFromFCM(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;

    print("Notification data: ${data.toString()}");
    print("Notification title: ${notification?.title}");
    print("Notification body: ${notification?.body}");
    print("Notification : ${notification?.toMap()}");

    await showNotificationWithData(
      title: notification?.title ?? data['title'] ?? 'Thông báo',
      body: notification?.body ?? data['body'] ?? '',
      data: data,
    );
  }
}


// // Cách đơn giản
// await LocalNotificationService.instance.showNotification(
//   title: "Đặt xe thành công",
//   body: "Chuyến đi của bạn đã được xác nhận",
// );

// // Cách nâng cao (có dữ liệu để điều hướng khi nhấn)
// await LocalNotificationService.instance.showNotificationWithData(
//   title: "Có chuyến xe mới",
//   body: "Ai đó vừa đặt chuyến đi đến TP.HCM",
//   data: {
//     "type": "new_ride",
//     "ride_id": "12345",
//     "screen": "booking_detail",
//   },
// );