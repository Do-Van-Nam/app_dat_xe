import 'dart:io';

class RemoteConfigModel {
  final bool maintenanceMode;
  final String maintenanceMessage;
  final String minVersion;
  final String latestVersion;

  RemoteConfigModel({
    required this.maintenanceMode,
    required this.maintenanceMessage,
    required this.minVersion,
    required this.latestVersion,
  });

  factory RemoteConfigModel.defaultValue() {
    return RemoteConfigModel(
      maintenanceMode: false,
      maintenanceMessage: 'Hệ thống đang bảo trì',
      minVersion: '8.0.0',
      latestVersion: '8.0.0',
    );
  }

  Map<String, dynamic> toJson() => {
    'maintenanceMode': maintenanceMode,
    'maintenanceMessage': maintenanceMessage,
    'minVersion': minVersion,
    'latestVersion': latestVersion,
  };

  factory RemoteConfigModel.fromJsonRemote(Map<String, dynamic> json) {
    return RemoteConfigModel(
      maintenanceMode: json['maintenance_mode'] ?? false,
      maintenanceMessage: json['maintenance_message'] ?? '',
      minVersion: Platform.isAndroid ? json['min_app_version_android'] : json['min_app_version_ios'] ?? '8.0.0',
      latestVersion: Platform.isAndroid ? json['latest_app_version_android'] : json['latest_app_version_ios'] ?? '8.0.0',
    );
  }
  factory RemoteConfigModel.fromJsonCache(Map<String, dynamic> json) {
    return RemoteConfigModel(
      maintenanceMode: json['maintenanceMode'] ?? false,
      maintenanceMessage: json['maintenanceMessage'] ?? '',
      minVersion: json['minVersion'] ?? '8.0.0',
      latestVersion: json['latestVersion'] ?? '8.0.0',
    );
  }
}
