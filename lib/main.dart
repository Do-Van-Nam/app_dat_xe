import 'dart:async';
import 'dart:ui';

import 'package:demo_app/app.dart';
import 'package:demo_app/config/app_config.dart';
import 'package:demo_app/main/data/service/google_sign_in_service.dart';
import 'package:demo_app/main/utils/constant.dart';
import 'package:demo_app/main/utils/device_utils.dart';
import 'package:demo_app/main/utils/service/firebase_messaging_service.dart';
import 'package:demo_app/main/utils/service/local_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'config/config_dev.dart';
import 'config/config_prod.dart';
import 'config/config_staging.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ====================== ERROR HANDLING (FAIL-SAFE) ======================
  FlutterError.onError = (FlutterErrorDetails details) {
    try {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    } catch (_) {
      debugPrint('⚠️ Crashlytics chưa sẵn sàng');
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    try {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    } catch (_) {
      debugPrint('⚠️ Crashlytics chưa sẵn sàng');
    }
    return true;
  };

  // ====================== RUN APP NGAY (KHÔNG CHỜ FIREBASE) ======================
  final AppConfig appConfig = _getCurrentConfig();
  AppConfig.init(appConfig);
  await DeviceUtils.init();
//debug
  await initContants();

  runApp(App(config: appConfig));

  // ====================== INIT SAU (KHÔNG BLOCK UI) ======================
  unawaited(_initServices());
}

Future<void> _initServices() async {
  // ====================== FIREBASE ======================
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint("✅ Firebase initialized");
    }
  } catch (e) {
    debugPrint("❌ Firebase init error: $e");
  }

  // ====================== GOOGLE SIGN IN ======================
  try {
    await GoogleAuthService().initialize();
    debugPrint("✅ Google Sign In initialized");
  } catch (e) {
    debugPrint("❌ GoogleAuthService error: $e");
  }

  // ====================== LOCAL NOTIFICATION ======================
  try {
    await LocalNotificationService.instance.init();
    debugPrint("✅ Local notification initialized");
  } catch (e) {
    debugPrint("❌ Local notification error: $e");
  }

  // ====================== FIREBASE MESSAGING ======================
  try {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await FirebaseMessagingService.initialize();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('🔔 Foreground message: $message');
      LocalNotificationService.instance.showFromFCM(message);
    });

    debugPrint("✅ Firebase Messaging initialized");
  } catch (e) {
    debugPrint("❌ Firebase Messaging error: $e");
  }

  // ====================== DEVICE INFO ======================
  try {
    await DeviceUtils.saveDeviceInfoToPrefs();
  } catch (e) {
    debugPrint("❌ Device info error: $e");
  }

  // ====================== LOCATION ======================
  try {
    await _requestLocationPermission();
  } catch (e) {
    debugPrint("❌ Location error: $e");
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    debugPrint('🔕 Background message: $message');
    LocalNotificationService.instance.showFromFCM(message);
  } catch (e) {
    debugPrint('❌ Background handler error: $e');
  }
}

Future<void> _requestLocationPermission() async {
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) return;

    debugPrint('✅ Location permission: $permission');
  } catch (e) {
    debugPrint('❌ Location error: $e');
  }
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
