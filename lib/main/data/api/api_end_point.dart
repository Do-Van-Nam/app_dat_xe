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

  // goong
  // https://rsapi.goong.io/place/autocomplete
  static String get DOMAIN_GOONG => "https://rsapi.goong.io";
  static String get DOMAIN_GOONG_PLACE_AUTOCOMPLETE =>
      "$DOMAIN_GOONG/place/autocomplete";
  static String get DOMAIN_GOONG_PLACE_DETAIL => "$DOMAIN_GOONG/place/detail";

// chuyen xe
// khach hang
  static String get DOMAIN_RIDE_DRAFT => "$DOMAIN_API/ride/draft";
  static String DOMAIN_RIDE_VEHICLES(dynamic rideId) =>
      "$DOMAIN_API/ride/$rideId/vehicles";
  static String DOMAIN_RIDE_PRICE(dynamic rideId) =>
      "$DOMAIN_API/ride/$rideId/price";
  static String DOMAIN_RIDE_VOUCHER(dynamic rideId) =>
      "$DOMAIN_API/ride/$rideId/voucher";
  static String DOMAIN_RIDE_CONFIRM(dynamic rideId) =>
      "$DOMAIN_API/ride/$rideId/confirm";
  static String DOMAIN_RIDE_CANCEL(dynamic rideId) =>
      "$DOMAIN_API/ride/$rideId/cancel";

// chuyen xe
// tai xe
  static String get DOMAIN_DRIVER_STATUS => "$DOMAIN_API/driver/status";
  static String DOMAIN_DRIVER_RIDE_ACCEPT(dynamic rideId) =>
      "$DOMAIN_API/driver/ride/$rideId/accept";
  static String DOMAIN_DRIVER_RIDE_REJECT(dynamic rideId) =>
      "$DOMAIN_API/driver/ride/$rideId/reject";
  static String DOMAIN_DRIVER_RIDE_CANCEL(dynamic rideId) =>
      "$DOMAIN_API/driver/ride/$rideId/cancel";

  // homepage
  static String get DOMAIN_HOME_PAGE => "$DOMAIN_API/homepage";

  // Finance
  static String get DOMAIN_SPENDING_SUMMARY =>
      "$DOMAIN_API/finance/spending-summary";

  // Vouchers
  static String get DOMAIN_VOUCHERS => "$DOMAIN_API/vouchers";
  static String DOMAIN_VOUCHER_DETAIL(dynamic id) => "$DOMAIN_VOUCHERS/$id";
  static String DOMAIN_SAVE_VOUCHER(dynamic id) => "$DOMAIN_VOUCHERS/$id/save";
  static String DOMAIN_APPLY_QUICK_VOUCHER(dynamic id) =>
      "$DOMAIN_VOUCHERS/$id/apply-quick";
  static String get DOMAIN_REWARDS_OVERVIEW =>
      "$DOMAIN_API/finance/rewards/overview";
  static String get DOMAIN_REWARDS_HISTORY =>
      "$DOMAIN_API/finance/rewards/history";
  static String DOMAIN_REWARDS_HISTORY_DETAIL(dynamic id) =>
      "$DOMAIN_API/finance/rewards/history/$id";

  // Driver Registration
  static String get DOMAIN_DRIVER_REGISTER => "$DOMAIN_API/driver/register";
  static String get DOMAIN_DRIVER_REGISTER_SEND_OTP =>
      "$DOMAIN_DRIVER_REGISTER/send-otp";
  static String get DOMAIN_DRIVER_REGISTER_SUBMIT =>
      "$DOMAIN_DRIVER_REGISTER/submit";
}
