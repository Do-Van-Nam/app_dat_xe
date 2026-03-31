import 'package:demo_app/main/ui/activity/activity_page.dart';
import 'package:demo_app/main/ui/auth/forget_password/forget_password_page.dart';
import 'package:demo_app/main/ui/auth/reset_password/reset_password_page.dart';
import 'package:demo_app/main/ui/auth/otp/otp_page.dart';
import 'package:demo_app/main/ui/auth/signup/signup_page.dart';
import 'package:demo_app/main/ui/book_vehicle/airport_booking/airport_booking_page.dart';
import 'package:demo_app/main/ui/book_vehicle/booking/booking_page.dart';
import 'package:demo_app/main/ui/book_vehicle/search_destination/search_destination_page.dart';
import 'package:demo_app/main/ui/book_vehicle/tracking/tracking_page.dart';
import 'package:demo_app/main/ui/language/language_page.dart';
import 'package:demo_app/main/ui/main_page.dart';
import 'package:demo_app/main/ui/notification/notification_page.dart';
import 'package:demo_app/main/ui/profile/edit_profile/edit_profile_page.dart';
import 'package:demo_app/main/ui/profile/expense_management/expense_management_page.dart';
import 'package:demo_app/main/ui/profile/points_wallet/points_wallet_page.dart';
import 'package:demo_app/main/ui/profile/profile_page.dart';
import 'package:demo_app/main/ui/profile/voucher/voucher_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'main/ui/auth/login/login_page.dart';
import 'main/ui/splash/splash_page.dart';

const String PATH_SPLASH = "/";

const String PATH_HOME = "/main";
const String PATH_PROFILE = "/profile";
const String PATH_ACTIVITY = "/activity";

// auth
const String PATH_LOGIN = "/login";
const String PATH_SIGNUP = "/signup";
const String PATH_FORGOT_PASSWORD = "/forgot-password";
const String PATH_RESET_PASSWORD = "/reset-password";
const String PATH_VERIFY_OTP = "/verify-otp";
const String PATH_LANGUAGE = "/language";

//  profile subpath
const String PATH_VOUCHER = "/voucher";
const String PATH_EDIT_PROFILE = "/edit-profile";
const String PATH_POINTS_WALLET = "/points-wallet";
const String PATH_EXPENSE_MANAGEMENT = "/expense-management";

const String PATH_NOTIFICATION = "/notification";

//booking
const String PATH_SEARCH_DESTINATION = "/search-destination";
const String PATH_BOOKING = "/booking";
const String PATH_TRACKING = "/tracking";
const String PATH_AIRPORT_BOOKING = "/airport-booking";

// chatbot
const String PATH_CHATBOT_INTRO = "/chatbot-info";
const String PATH_CHATBOT = "/chatbot";
const String PATH_LOGIN_OTP = "/login_otp";
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();
final GoRouter router = GoRouter(
  initialLocation: PATH_SPLASH,

  routes: [
    GoRoute(
      path: PATH_SPLASH,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(path: PATH_HOME, builder: (context, state) => MainPage()),
    GoRoute(path: PATH_PROFILE, builder: (context, state) => ProfilePage()),
    GoRoute(path: PATH_ACTIVITY, builder: (context, state) => ActivityPage()),
    GoRoute(path: PATH_LOGIN, builder: (context, state) => LoginPage()),
    GoRoute(path: PATH_SIGNUP, builder: (context, state) => SignupPage()),
    GoRoute(
      path: PATH_FORGOT_PASSWORD,
      builder: (context, state) => ForgetPasswordPage(),
    ),
    GoRoute(
      path: PATH_RESET_PASSWORD,
      builder: (context, state) {
        final phone = state.extra as String?;
        if (phone == null) {
          return const SplashPage();
        }
        return ResetPasswordPage(phoneNumber: phone);
      },
    ),
    GoRoute(
      path: PATH_VERIFY_OTP,
      builder: (context, state) {
        final phone = state.extra as String?;
        if (phone == null) {
          return const SplashPage();
        }
        return OtpPage(phoneNumber: phone);
      },
    ),
    GoRoute(
      path: PATH_LANGUAGE,
      builder: (context, state) => LanguagePage(),
    ),
    GoRoute(
      path: PATH_VOUCHER,
      builder: (context, state) => VoucherPage(),
    ),
    GoRoute(
      path: PATH_POINTS_WALLET,
      builder: (context, state) => PointsWalletPage(),
    ),
    GoRoute(
      path: PATH_EXPENSE_MANAGEMENT,
      builder: (context, state) => ExpenseManagementPage(),
    ),
    GoRoute(
      path: PATH_EDIT_PROFILE,
      builder: (context, state) => EditProfilePage(),
    ),
    GoRoute(
      path: PATH_NOTIFICATION,
      builder: (context, state) => NotificationPage(),
    ),

    // booking
    GoRoute(
      path: PATH_SEARCH_DESTINATION,
      builder: (context, state) => SearchDestinationPage(),
    ),
    GoRoute(
      path: PATH_BOOKING,
      builder: (context, state) => BookingPage(),
    ),
    GoRoute(
      path: PATH_TRACKING,
      builder: (context, state) => TrackingPage(),
    ),
    GoRoute(
      path: PATH_AIRPORT_BOOKING,
      builder: (context, state) => AirportBookingPage(),
    ),
  ],
  // redirect: (context, state) {
  //   final isLoggedIn = UserInfoModel.instance.username.isNotEmpty;
  //   final isFirstOpenApp = AppConfig.instance.isFirstOpenApp;
  //
  //   AppLogger().logError(
  //     "CheckApp: isLoggedIn=$isLoggedIn, isFirstOpenApp=$isFirstOpenApp",
  //   );
  //
  //   // if (isLoggedIn && state.matchedLocation != PATH_HOME) {
  //   //   return PATH_HOME;
  //   // }
  //
  //   if (!isLoggedIn && state.matchedLocation == PATH_LOGIN) {
  //     if (isFirstOpenApp) {
  //       return PATH_HOME;
  //     } else {
  //       return PATH_LOGIN;
  //     }
  //   }
  //
  //   return null;
  // },
);
