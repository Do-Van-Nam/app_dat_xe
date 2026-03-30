import 'dart:convert';

import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../../data/model/remote_config_model.dart';

class RemoteConfigKey {
  static const String REMOTE_CONFIG_APP = "REMOTE_CONFIG_APP";
}

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();

  factory RemoteConfigService() => _instance;

  RemoteConfigService._internal();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  late RemoteConfigModel config;

  Future<void> init() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 5),
          // minimumFetchInterval: Duration.zero, //test dev
          minimumFetchInterval: const Duration(minutes: 5), //prod
        ),
      );

      await _remoteConfig.fetchAndActivate();

      final jsonString = _remoteConfig.getString(
        RemoteConfigKey.REMOTE_CONFIG_APP,
      );

      if (jsonString.isEmpty) {
        config = RemoteConfigModel.defaultValue();
        return;
      }

      final Map<String, dynamic> json = jsonDecode(jsonString);

      config = RemoteConfigModel.fromJsonRemote(json);
      await SharePreferenceUtil.saveConfig(config);
    } catch (e) {
      final cached = await SharePreferenceUtil.loadConfig();
      config = cached ?? RemoteConfigModel.defaultValue();
    }
  }
}
