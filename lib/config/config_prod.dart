import 'app_config.dart';

final AppConfig prodConfig = AppConfig(
  environment: Environment.prod,
  apiBaseUrl: 'https://api.example.com',
  enableLogging: false,
  appName: 'Demo App',
  socketUrl: 'http://[IP_ADDRESS]',
);
