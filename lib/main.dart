import 'dart:async';
import 'package:demo_app/main/utils/service/firebase_messaging_service.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui';
import 'package:demo_app/app.dart';
import 'package:demo_app/config/app_config.dart';
import 'package:demo_app/main/data/service/google_sign_in_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'config/config_dev.dart';
import 'config/config_prod.dart';
import 'config/config_staging.dart';
import 'firebase_options.dart';
import 'main/utils/device_utils.dart';
import 'main/utils/service/local_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ====================== ERROR HANDLING ======================
  FlutterError.onError = (FlutterErrorDetails details) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // ====================== INITIALIZE FIREBASE ======================
  try {
    // Kiểm tra để tránh duplicate Firebase App
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print("Firebase initialized successfully");
    }
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  // ====================== GOOGLE SIGN IN ======================
  try {
    await GoogleAuthService().initialize();
    print("Google Sign In initialized");
  } catch (e) {
    print("GoogleAuthService initialize error: $e");
  }

  // ====================== LOCAL NOTIFICATION ======================
  try {
    await LocalNotificationService.instance.init();
    print("Local notification initialized");
  } catch (e) {
    print("Local notification init error: $e");
  }

  // ====================== FIREBASE MESSAGING ======================
  await FirebaseMessagingService.initialize();

  // ====================== FOREGROUND & BACKGROUND MESSAGING ======================
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('🔔 Foreground message: ${message.toString()}');
    LocalNotificationService.instance.showFromFCM(message);
  });

  // ====================== APP CONFIG ======================
  final AppConfig appConfig = _getCurrentConfig();

  AppConfig.init(appConfig);

  // Lưu device info (ID, name, token) vào SharedPreferences
  await DeviceUtils.saveDeviceInfoToPrefs();

  // ====================== LOCATION PERMISSION ======================
  await _requestLocationPermission();

  // Chạy app
  runApp(
      App(config: devConfig)); // ← Dùng appConfig thay vì hard-code devConfig
}

/// Yêu cầu quyền vị trí khi mở app.
/// Nếu đã bị từ chối vĩnh viễn thì bỏ qua (không force mở Settings).
Future<void> _requestLocationPermission() async {
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('⚠️ Location services are disabled.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      print('⚠️ Location permission permanently denied.');
      return;
    }

    print('✅ Location permission: $permission');
  } catch (e) {
    print('❌ _requestLocationPermission error: $e');
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('🔕 Background message: ${message.toString()}');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  LocalNotificationService.instance.showFromFCM(message);
}

// Hàm chọn config theo môi trường
AppConfig _getCurrentConfig() {
  const String env = String.fromEnvironment('ENV', defaultValue: 'dev');

  switch (env.toLowerCase()) {
    case 'prod':
      return prodConfig;
    case 'staging':
      return stagingConfig;
    case 'dev':
    default:
      return devConfig;
  }
}
// # Chạy Dev (mặc định)
// flutter run -t lib/main.dart --dart-define=ENV=dev

// # Chạy Staging
// flutter run -t lib/main.dart --dart-define=ENV=staging

// # Chạy Production
// flutter run -t lib/main.dart --dart-define=ENV=prod

// # Build APK Production
// flutter build apk -t lib/main.dart --dart-define=ENV=prod --release
