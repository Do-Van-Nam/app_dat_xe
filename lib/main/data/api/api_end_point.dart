import 'package:demo_app/config/app_config.dart';

class ApiEndPoint {
  // static String DOMAIN_API = "https://demo.app/start";
static String get DOMAIN_API => AppConfig.instance.apiBaseUrl;
static String get login => "$DOMAIN_API/auth/login";
}
