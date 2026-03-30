import 'app_config.dart';

final AppConfig stagingConfig = AppConfig(
  environment: Environment.staging,
  apiBaseUrl: 'https://api.staging.example.com',
  enableLogging: true,
  appName: 'Demo App (Staging)',
);