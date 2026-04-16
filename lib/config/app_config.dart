enum Environment { dev, staging, prod }

class AppConfig {
  final Environment environment;
  final String apiBaseUrl;
  final bool enableLogging;
  final String appName;
  final String socketUrl;

  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.enableLogging,
    required this.appName,
    required this.socketUrl,
  });
// Singleton pattern
  AppConfig._internal(this.environment, this.apiBaseUrl, this.appName,
      this.enableLogging, this.socketUrl);

  static late final AppConfig instance;

  // Khởi tạo một lần duy nhất
  static void init(AppConfig config) {
    instance = config;
  }

  // Helper
  bool get isDev => environment == Environment.dev;
  bool get isStaging => environment == Environment.staging;
  bool get isProd => environment == Environment.prod;
}
