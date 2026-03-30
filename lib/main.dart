import 'dart:async';
import 'dart:ui';
import 'package:demo_app/app.dart';
import 'package:demo_app/config/app_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'config/config_dev.dart';
import 'config/config_prod.dart';
import 'config/config_staging.dart';
import 'firebase_options.dart';
import 'main/utils/service/local_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup error handlers first (non-blocking)
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  // Initialize Firebase (required before other Firebase services)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Setup background message handler (non-blocking registration)
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  
  final AppConfig appConfig = _getCurrentConfig();
  AppConfig.init(appConfig);
  // runApp(App(config: appConfig));
  runApp(App(config: devConfig));
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