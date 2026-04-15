import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    // Yêu cầu quyền
    await _messaging.requestPermission();

    // Lấy token lần đầu
    String? token = await _messaging.getToken();
    print("FCM Token: $token");

    // Gửi token lên server
    if (token != null) {
      await _sendTokenToServer(token);
    }

    // Lắng nghe khi token thay đổi (rất quan trọng)
    _messaging.onTokenRefresh.listen((newToken) {
      print("FCM Token mới: $newToken");
      _sendTokenToServer(newToken);
    });
  }

  static Future<void> _sendTokenToServer(String token) async {
    // TODO: Gọi API gửi token lên backend của bạn
    // Ví dụ:
    // await AuthRepository().updateFcmToken(token);
    print("Đã gửi token lên server: $token");
  }
}
