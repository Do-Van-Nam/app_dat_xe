import 'package:demo_app/config/app_config.dart';

class ApiEndPoint {
  // static String DOMAIN_API = "https://demo.app/start";
  static String get DOMAIN_API => "${AppConfig.instance.apiBaseUrl}/api/v1";

  // Auth
  static String get DOMAIN_AUTH => "$DOMAIN_API/auth";
  static String get DOMAIN_LOGIN => "$DOMAIN_AUTH/login";
  static String get DOMAIN_AUTHENTICATE_OTP => "$DOMAIN_AUTH/authenticate-otp";
  static String get DOMAIN_REGISTER => "$DOMAIN_AUTH/register";
  static String get DOMAIN_RESET_PASSWORD => "$DOMAIN_AUTH/reset-password";
  static String get DOMAIN_ME => "$DOMAIN_AUTH/me";
  static String get DOMAIN_LOGOUT => "$DOMAIN_AUTH/logout";
  static String get DOMAIN_GOOGLE_LOGIN => "$DOMAIN_AUTH/google-login";
  static String get DOMAIN_APPLE_LOGIN => "$DOMAIN_AUTH/apple-login";
  static String get DOMAIN_FORGOT_PASSWORD => "$DOMAIN_AUTH/forgot-password";

  // User Profile
  static String get DOMAIN_USER_PROFILE => "$DOMAIN_API/user/profile";
  static String get DOMAIN_USER_PROFILE_EDIT => "$DOMAIN_USER_PROFILE/edit";
  static String get DOMAIN_VERIFY_PROFILE_OTP =>
      "$DOMAIN_USER_PROFILE/verify-otp";
  static String get DOMAIN_CHANGE_PASSWORD =>
      "$DOMAIN_USER_PROFILE/change-password";

  // User Addresses
  static String get DOMAIN_USER_ADDRESSES => "$DOMAIN_API/user/addresses";

  static String DOMAIN_USER_ADDRESS_DETAIL(dynamic id) =>
      "$DOMAIN_USER_ADDRESSES/$id";

  static String DOMAIN_USER_ADDRESS_DEFAULT(dynamic id) =>
      "$DOMAIN_USER_ADDRESSES/$id/default";
}
