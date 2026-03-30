import 'app_config.dart';

final AppConfig devConfig = AppConfig(
  environment: Environment.dev,
  apiBaseUrl: 'https://api.dev.example.com',
  enableLogging: true,
  appName: 'Demo App (Dev)',
);