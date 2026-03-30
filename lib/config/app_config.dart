enum Environment { dev, staging, prod }

class AppConfig {
  final Environment environment;
  final String apiBaseUrl;
  final bool enableLogging;
  final String appName;

  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.enableLogging,
    required this.appName,
  });
// Singleton pattern
  AppConfig._internal(this.environment, this.apiBaseUrl, this.appName, this.enableLogging);

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