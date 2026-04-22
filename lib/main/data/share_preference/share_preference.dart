import 'dart:convert';

import 'package:demo_app/main/data/model/goong/location.dart';
import 'package:demo_app/main/data/model/goong/place_detail.dart';
import 'package:demo_app/main/data/model/ride/ride.dart';
import 'package:demo_app/main/data/model/user/user.dart';
import 'package:demo_app/main/data/model/user_info_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/remote_config_model.dart';

class ShareKey {
  static const String KEY_CHANGE_LANGUAGE = "KEY_CHANGE_LANGUAGE";
  static const String KEY_USER_INFO = "KEY_USER_INFO";
  static const String KEY_FB_TOKEN = "KEY_FB_TOKEN";
  static const String KEY_LOG_FILE = "KEY_LOG_FILE";
  static const String KEY_FIRST_OPEN_APP = "KEY_FIRST_OPEN_APP";
  static const String KEY_ACCESS_TOKEN = "KEY_ACCESS_TOKEN";
  static const String KEY_PHONE_NUMBER = "KEY_PHONE_NUMBER";
  static const String KEY_REFRESH_TOKEN = "KEY_REFRESH_TOKEN";
  static const String KEY_LOGIN_WITH_OTP = "KEY_LOGIN_WITH_OTP";
  static const String KEY_REMOTE_CONFIG = "KEY_REMOTE_CONFIG";
  static const String KEY_CHANGE_OPEN_APP = "KEY_CHANGE_OPEN_APP";
  static const String KEY_DEVICE_ID = "KEY_DEVICE_ID";
  static const String KEY_DEVICE_NAME = "KEY_DEVICE_NAME";
  static const String KEY_DEVICE_TOKEN = "KEY_DEVICE_TOKEN";
  static const String KEY_DEVICE_TYPE = "KEY_DEVICE_TYPE";
  static const String KEY_OTP_CODE = "KEY_OTP_CODE";
  static const String KEY_LOGIN_TOKEN = "KEY_LOGIN_TOKEN";
  static const String KEY_CURRENT_RIDE = "KEY_CURRENT_RIDE";
  static const String KEY_CURRENT_POSITION = "KEY_CURRENT_POSITION";
  static const String KEY_CURRENT_PICKUP = "KEY_CURRENT_PICKUP";
  static const String KEY_CURRENT_DROPOFF = "KEY_CURRENT_DROPOFF";
  static const String KEY_HOME_ADDRESS = "KEY_HOME_ADDRESS";
  static const String KEY_WORK_ADDRESS = "KEY_WORK_ADDRESS";
}

class SharePreferenceUtil {
  static Future<SharedPreferences> _prefs() async {
    return await SharedPreferences.getInstance();
  }

  static Future<void> setString(String key, String value) async {
    final prefs = await _prefs();
    await prefs.setString(key, value);
  }

  static Future<String> getString(
    String key, {
    String defaultValue = '',
  }) async {
    final prefs = await _prefs();
    return prefs.getString(key) ?? defaultValue;
  }

  static Future<void> setBool(String key, bool value) async {
    final prefs = await _prefs();
    await prefs.setBool(key, value);
  }

  static Future<bool> getBool(
    String key, {
    bool defaultValue = false,
  }) async {
    final prefs = await _prefs();
    return prefs.getBool(key) ?? defaultValue;
  }

  static Future<void> setInt(String key, int value) async {
    final prefs = await _prefs();
    await prefs.setInt(key, value);
  }

  static Future<int> getInt(
    String key, {
    int defaultValue = 0,
  }) async {
    final prefs = await _prefs();
    return prefs.getInt(key) ?? defaultValue;
  }

  static Future<void> setDouble(String key, double value) async {
    final prefs = await _prefs();
    await prefs.setDouble(key, value);
  }

  static Future<double> getDouble(
    String key, {
    double defaultValue = 0.0,
  }) async {
    final prefs = await _prefs();
    return prefs.getDouble(key) ?? defaultValue;
  }

  static Future<bool> remove(String key) async {
    final prefs = await _prefs();
    return prefs.remove(key);
  }

  static Future<bool> clear() async {
    final prefs = await _prefs();
    return prefs.clear();
  }

  static Future saveLanguage(String languageCode) async {
    return setString(ShareKey.KEY_CHANGE_LANGUAGE, languageCode);
  }

  static Future<String> getLanguageCode() async {
    return getString(
      ShareKey.KEY_CHANGE_LANGUAGE,
      defaultValue: 'en',
    );
  }

  // device info
  static Future saveDeviceId(String deviceId) async {
    return setString(ShareKey.KEY_DEVICE_ID, deviceId);
  }

  static Future<String> getDeviceId() async {
    return getString(
      ShareKey.KEY_DEVICE_ID,
      defaultValue: '',
    );
  }

  static Future saveDeviceName(String deviceName) async {
    return setString(ShareKey.KEY_DEVICE_NAME, deviceName);
  }

  static Future<String> getDeviceName() async {
    return getString(
      ShareKey.KEY_DEVICE_NAME,
      defaultValue: '',
    );
  }

  static Future saveDeviceToken(String deviceToken) async {
    return setString(ShareKey.KEY_DEVICE_TOKEN, deviceToken);
  }

  static Future<String> getDeviceToken() async {
    return getString(
      ShareKey.KEY_DEVICE_TOKEN,
      defaultValue: '',
    );
  }

  static Future saveDeviceType(String deviceType) async {
    return setString(ShareKey.KEY_DEVICE_TYPE, deviceType);
  }

  static Future<String> getDeviceType() async {
    return getString(
      ShareKey.KEY_DEVICE_TYPE,
      defaultValue: '',
    );
  }

  static Future<void> saveUser(User? model) async {
    if (model == null) return;
    final jsonString = jsonEncode(model.toJson());
    await setString(ShareKey.KEY_USER_INFO, jsonString);
  }

  static Future<User?> getUser() async {
    final jsonString = await getString(ShareKey.KEY_USER_INFO);
    if (jsonString.isEmpty) return null;

    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    final user = User.fromJson(jsonMap);

    return user;
  }

  static Future<void> saveCurrentPickup(GoongPlaceDetail? model) async {
    // if (model == null) return;
    final jsonString = jsonEncode(model?.toJson());
    await setString(ShareKey.KEY_CURRENT_PICKUP, jsonString);
  }

  static Future<GoongPlaceDetail?> getCurrentPickup() async {
    final jsonString = await getString(ShareKey.KEY_CURRENT_PICKUP);

    if (jsonString == null || jsonString.isEmpty || jsonString == "null") {
      return null;
    }

    final decoded = jsonDecode(jsonString);

    if (decoded == null || decoded is! Map<String, dynamic>) {
      return null;
    }

    return GoongPlaceDetail.fromJson(decoded);
  }

  static Future<void> saveHomeAddress(GoongLocation? model) async {
    // if (model == null) return;
    final jsonString = jsonEncode(model?.toJson());
    await setString(ShareKey.KEY_HOME_ADDRESS, jsonString);
  }

  static Future<GoongLocation?> getHomeAddress() async {
    final jsonString = await getString(ShareKey.KEY_HOME_ADDRESS);
    if (jsonString.isEmpty || jsonString == null || jsonString == "null") {
      return null;
    }

    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    final user = GoongLocation.fromJson(jsonMap);

    return user;
  }

  static Future<void> saveWorkAddress(GoongLocation? model) async {
    // if (model == null) return;
    final jsonString = jsonEncode(model?.toJson());
    await setString(ShareKey.KEY_WORK_ADDRESS, jsonString);
  }

  static Future<GoongLocation?> getWorkAddress() async {
    final jsonString = await getString(ShareKey.KEY_WORK_ADDRESS);
    if (jsonString.isEmpty || jsonString == null || jsonString == "null") {
      return null;
    }

    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    final user = GoongLocation.fromJson(jsonMap);

    return user;
  }

  static Future<void> saveCurrentDropOff(GoongPlaceDetail? model) async {
    // if (model == null) return;
    final jsonString = jsonEncode(model?.toJson());
    await setString(ShareKey.KEY_CURRENT_DROPOFF, jsonString);
  }

  static Future<GoongPlaceDetail?> getCurrentDropOff() async {
    final jsonString = await getString(ShareKey.KEY_CURRENT_DROPOFF);
    if (jsonString.isEmpty || jsonString == null || jsonString == "null") {
      return null;
    }

    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    final user = GoongPlaceDetail.fromJson(jsonMap);

    return user;
  }

  static Future<void> saveCurrentRide(Ride? model) async {
    if (model == null) return;
    final jsonString = jsonEncode(model.toJson());
    await setString(ShareKey.KEY_CURRENT_RIDE, jsonString);
  }

  static Future<Ride?> getCurrentRide() async {
    final jsonString = await getString(ShareKey.KEY_CURRENT_RIDE);
    if (jsonString.isEmpty) return null;

    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    final ride = Ride.fromJson(jsonMap);

    return ride;
  }

  static Future<void> saveCurrentPosition(Position? model) async {
    if (model == null) return;
    final jsonString = jsonEncode(model.toJson());
    await setString(ShareKey.KEY_CURRENT_POSITION, jsonString);
  }

  static Future<Position?> getCurrentPosition() async {
    final jsonString = await getString(ShareKey.KEY_CURRENT_POSITION);
    if (jsonString.isEmpty) return null;

    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    final position = Position.fromMap(jsonMap);

    return position;
  }

  static Future saveToken(String token) async {
    return setString(ShareKey.KEY_FB_TOKEN, token);
  }

  static Future<String> getToken() async {
    return getString(ShareKey.KEY_FB_TOKEN);
  }

  static Future saveLoginToken(String token) async {
    return setString(ShareKey.KEY_LOGIN_TOKEN, token);
  }

  static Future<String> getLoginToken() async {
    return getString(ShareKey.KEY_LOGIN_TOKEN);
  }

  static Future saveOtpCode(String otpCode) async {
    return setString(ShareKey.KEY_OTP_CODE, otpCode);
  }

  static Future<String> getOtpCode() async {
    return getString(ShareKey.KEY_OTP_CODE);
  }

  static Future saveLogFile(bool enable) async {
    return setBool(ShareKey.KEY_LOG_FILE, enable);
  }

  static Future<bool> enableLogFile() async {
    return getBool(ShareKey.KEY_LOG_FILE);
  }

  static Future<bool> removeKey(String key) async {
    return remove(key);
  }

  static Future<void> saveConfig(RemoteConfigModel model) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(
        ShareKey.KEY_REMOTE_CONFIG, jsonEncode(model.toJson()));
  }

  static Future<RemoteConfigModel?> loadConfig() async {
    final pref = await SharedPreferences.getInstance();
    final json = pref.getString(ShareKey.KEY_REMOTE_CONFIG);
    if (json == null) return null;
    return RemoteConfigModel.fromJsonCache(jsonDecode(json));
  }
}
