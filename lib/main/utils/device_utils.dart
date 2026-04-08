import 'dart:io';

import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceUtils {
  static final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  static Map<String, dynamic> deviceData = {};

  // Lấy thông tin thiết bị
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    // Lấy thông tin ứng dụng
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (!deviceData.containsKey("appName")) {
      deviceData['appName'] = packageInfo.appName;
    }
    if (!deviceData.containsKey("packageName")) {
      deviceData['packageName'] = packageInfo.packageName;
    }
    if (!deviceData.containsKey("version")) {
      deviceData['version'] = packageInfo.version;
    }
    if (!deviceData.containsKey("buildNumber")) {
      deviceData['buildNumber'] = packageInfo.buildNumber;
    }
    if (!deviceData.containsKey("platform")) {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceData.addAll({
          'platform': 'Android',
          'model': androidInfo.model,
          'manufacturer': androidInfo.manufacturer,
          'androidVersion': androidInfo.version.release,
          'sdkVersion': androidInfo.version.sdkInt,
          'deviceId': androidInfo.id,
        });
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceData.addAll({
          'platform': 'iOS',
          'model': iosInfo.utsname.machine,
          'systemName': iosInfo.systemName,
          'systemVersion': iosInfo.systemVersion,
          'identifierForVendor': iosInfo.identifierForVendor,
        });
      }
    }
    return deviceData;
  }

  static String getPlatform() {
    if (deviceData.isEmpty) {
      getDeviceInfo();
    }
    return deviceData["platform"].toString().isEmpty
        ? ""
        : deviceData["platform"];
  }

  static String getVersion() {
    if (deviceData.isEmpty) {
      getDeviceInfo();
    }
    return deviceData["version"].toString().isEmpty
        ? ""
        : deviceData["version"];
  }

  static Future<String> getVersionName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var versionName = packageInfo.version;
    return versionName;
  }

  static String getPackageName() {
    if (deviceData.isEmpty) {
      getDeviceInfo();
    }
    return deviceData["packageName"].toString().isEmpty
        ? ""
        : deviceData["packageName"];
  }

  static String getAppName() {
    if (deviceData.isEmpty) {
      getDeviceInfo();
    }
    return deviceData["appName"].toString().isEmpty
        ? ""
        : deviceData["appName"];
  }

  static String getOSVersion() {
    if (deviceData.isEmpty) {
      getDeviceInfo();
    }
    if (Platform.isAndroid) {
      return deviceData["sdkVersion"].toString().isEmpty
          ? "0"
          : deviceData["sdkVersion"].toString();
    } else if (Platform.isIOS) {
      return deviceData["systemVersion"].toString().isEmpty
          ? "0"
          : deviceData["systemVersion"].toString();
    }
    return "";
  }

  static String getDeviceName() {
    if (deviceData.isEmpty) {
      getDeviceInfo();
    }
    if (Platform.isAndroid) {
      return deviceData["model"].toString().isEmpty ? "" : deviceData["model"];
    } else if (Platform.isIOS) {
      return deviceData["systemName"].toString().isEmpty
          ? ""
          : deviceData["systemName"];
    }
    return "";
  }

  static String getDeviceId() {
    if (deviceData.isEmpty) {
      getDeviceInfo();
    }

    if (Platform.isAndroid) {
      return deviceData["deviceId"]?.toString() ?? "";
    } else if (Platform.isIOS) {
      return deviceData["identifierForVendor"]?.toString() ?? "";
    }
    return "";
  }

  static Future<void> saveDeviceInfoToPrefs() async {
    try {
      await getDeviceInfo();
      final prefs = await SharedPreferences.getInstance();

      final String deviceId = getDeviceId();
      final String deviceName = getDeviceName();

      String? deviceToken = '';
      try {
        deviceToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        print('Could not get Firebase device token: $e');
      }

      await SharePreferenceUtil.saveDeviceId(deviceId);
      await SharePreferenceUtil.saveDeviceName(deviceName);
      await SharePreferenceUtil.saveDeviceToken(deviceToken ?? '');
    } catch (e) {
      print('Error saving device info to SharedPreferences: $e');
    }
  }
}
