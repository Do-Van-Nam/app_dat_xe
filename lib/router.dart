import 'package:demo_app/main/ui/activity/activity_page.dart';
import 'package:demo_app/main/ui/activity/trip_detail/trip_detail_page.dart';
import 'package:demo_app/main/ui/auth/driver_register/service_register/service_register_page.dart';
import 'package:demo_app/main/ui/auth/driver_register/upload_records/upload_records_page.dart';
import 'package:demo_app/main/ui/auth/forget_password/forget_password_page.dart';
import 'package:demo_app/main/ui/auth/reset_password/reset_password_page.dart';
import 'package:demo_app/main/ui/auth/otp/otp_page.dart';
import 'package:demo_app/main/ui/auth/signup/signup_page.dart';
import 'package:demo_app/main/ui/book_vehicle/airport_booking/airport_booking_page.dart';
import 'package:demo_app/main/ui/book_vehicle/book_for_family/book_for_family_page.dart';
import 'package:demo_app/main/ui/book_vehicle/booking/booking_page.dart';
import 'package:demo_app/main/ui/book_vehicle/interprovince_ride/interprovice_ride_page.dart';
import 'package:demo_app/main/ui/book_vehicle/interprovince_ride/trip_detail/tai_xe_nhan_page.dart';
import 'package:demo_app/main/ui/book_vehicle/interprovince_ride/waiting_driver/waiting_driver_page.dart';
import 'package:demo_app/main/ui/book_vehicle/rent_driver/rent_driver_page.dart';
import 'package:demo_app/main/ui/book_vehicle/finding_driver/finding_driver_page.dart';
import 'package:demo_app/main/ui/book_vehicle/search_destination/search_destination_page.dart';
import 'package:demo_app/main/ui/book_vehicle/tracking/tracking_page.dart';
import 'package:demo_app/main/ui/driver/map_sample.dart';
import 'package:demo_app/main/ui/driver/membership/membership_page.dart';
import 'package:demo_app/main/ui/food_delivery/cart/cart_page.dart';
import 'package:demo_app/main/ui/food_delivery/checkout/checkout_page.dart';
import 'package:demo_app/main/ui/food_delivery/food_delivery_page.dart';
import 'package:demo_app/main/ui/food_delivery/order_tracking/order_tracking_page.dart';
import 'package:demo_app/main/ui/language/language_page.dart';
import 'package:demo_app/main/ui/main_page.dart';
import 'package:demo_app/main/ui/notification/notification_page.dart';
import 'package:demo_app/main/ui/profile/edit_profile/edit_profile_page.dart';
import 'package:demo_app/main/ui/profile/expense_management/expense_management_page.dart';
import 'package:demo_app/main/ui/profile/points_wallet/points_wallet_page.dart';
import 'package:demo_app/main/ui/profile/profile_page.dart';
import 'package:demo_app/main/ui/profile/voucher/voucher_page.dart';
import 'package:demo_app/main/ui/shipping/delivery_info/delivery_info_page.dart';
import 'package:demo_app/main/ui/shipping/shipping_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'main/ui/auth/driver_register/waiting_approval/waiting_approval_page.dart';
import 'main/ui/auth/login/login_page.dart';
import 'main/ui/driver/main/driver_page.dart';
import 'main/ui/driver/payment_success/payment_success_page.dart';
import 'main/ui/driver/rating/rate_trip_page.dart';
import 'main/ui/driver/top_up/topup_page.dart';
import 'main/ui/driver/wallet/wallet_page.dart';
import 'main/ui/home/home_page.dart';
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
//driver auth
const String PATH_DRIVER_REGISTER = "/driver-register";
const String PATH_DRIVER_UPLOAD_RECORDS = "/driver-upload-records";
const String PATH_DRIVER_SERVICE_REGISTER = "/driver-service-register";
const String PATH_WAITING_APPROVAL = "/waiting-approval";

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
const String PATH_INTERCITY_BOOKING = "/intercity-booking";
const String PATH_INTERPROVINCE_RIDE = "/interprovince-ride";
const String PATH_BOOK_FOR_FAMILY = "/book-for-family";
const String PATH_RENT_DRIVER = "/rent-driver";
const String PATH_FINDING_DRIVER = "/finding-driver";
const String PATH_WAITING_DRIVER = "/waiting-driver";
const String PATH_TRIP_DETAIL = "/trip-detail";

//Shipping
const String PATH_SHIPPING = "/shipping";
const String PATH_DELIVERY_INFO = "/delivery-info";

// food
const String PATH_FOOD_INTRO = "/food-intro";
const String PATH_FOOD = "/food";
const String PATH_CART = "/cart";
const String PATH_CHECKOUT = "/checkout";
const String PATH_ORDER_TRACKING = "/order-tracking";

// driver
const String PATH_DRIVER_MAIN = "/driver-main";
const String PATH_RATE_TRIP = "/rate-trip";
const String PATH_MAP_SAMPLE = "/map-sample";
const String PATH_DRIVER_WALLET = "/driver-wallet";
const String PATH_DRIVER_MEMBERSHIP = "/driver-membership";
const String PATH_DRIVER_TOPUP = "/driver-topup";
const String PATH_PAYMENT_SUCCESS = "/payment-success";

// activity
const String PATH_ACTIVITY_TRIP_DETAIL = "/activity-trip-detail";

// chatbot
const String PATH_CHATBOT_INTRO = "/chatbot-info";
const String PATH_CHATBOT = "/chatbot";
const String PATH_LOGIN_OTP = "/login_otp";

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();
final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: PATH_SPLASH,

  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainPage(child: child);
      },
      routes: [
        GoRoute(path: PATH_HOME, builder: (context, state) => HomePage()),
        GoRoute(path: PATH_PROFILE, builder: (context, state) => ProfilePage()),
        GoRoute(
            path: PATH_ACTIVITY, builder: (context, state) => ActivityPage()),
        GoRoute(
          path: PATH_DRIVER_WALLET,
          builder: (context, state) => WalletPage(),
        ),
      ],
    ),

    GoRoute(
      path: PATH_SPLASH,
      builder: (context, state) => const SplashPage(),
    ),

    GoRoute(
        name: PATH_LOGIN,
        path: PATH_LOGIN,
        builder: (context, state) => LoginPage()),
    GoRoute(path: PATH_SIGNUP, builder: (context, state) => SignupPage()),
    GoRoute(
      path: PATH_FORGOT_PASSWORD,
      builder: (context, state) => ForgetPasswordPage(),
    ),
    GoRoute(
      path: PATH_RESET_PASSWORD,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final phone = extra?['phone'] as String?;
        final otpCode = extra?['otpCode'] as String?;

        if (phone == null ||
            otpCode == null ||
            phone.isEmpty ||
            otpCode.isEmpty) {
          return const SplashPage();
        }

        return ResetPasswordPage(
          phoneNumber: phone,
          otpCode: otpCode,
        );
      },
    ),
    GoRoute(
      path: PATH_VERIFY_OTP,
      builder: (context, state) {
        final data = state.extra as Map<String, String>?;

        final phone = data?['phone'];
        final oldPhone = data?['oldPhone'];
        final password = data?['password'];
        final fullName = data?['fullName'];
        final type = data?['type'] ?? "forget";
        if ((phone == null || password == null) && type == "signup") {
          return const SplashPage();
        }
        if (phone == null && (type == "forget" || type == "update_info")) {
          return const SplashPage();
        }
        return OtpPage(
            phoneNumber: phone,
            oldPhone: oldPhone,
            password: password,
            fullName: fullName,
            type: type);
      },
    ),
    GoRoute(
      path: PATH_LANGUAGE,
      builder: (context, state) => LanguagePage(),
    ),
//driver auth
    GoRoute(
      path: PATH_DRIVER_REGISTER,
      // builder: (context, state) => DriverRegisterPage(),
      builder: (context, state) => UploadRecordsPage(),
    ),
    GoRoute(
      path: PATH_DRIVER_UPLOAD_RECORDS,
      builder: (context, state) => UploadRecordsPage(),
    ),
    GoRoute(
      path: PATH_DRIVER_SERVICE_REGISTER,
      builder: (context, state) => ServiceRegisterPage(),
    ),
    GoRoute(
      path: PATH_WAITING_APPROVAL,
      builder: (context, state) => WaitingApprovalPage(),
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
      builder: (context, state) {
        final data = state.extra as Map<String, String>;

        final pickUp = data['pickUp']!;
        final dropOff = data['dropOff']!;

        return BookingPage(pickUp: pickUp, dropOff: dropOff);
      },
    ),
    GoRoute(
      path: PATH_TRACKING,
      builder: (context, state) => TrackingPage(),
    ),
    GoRoute(
      path: PATH_AIRPORT_BOOKING,
      builder: (context, state) => AirportBookingPage(),
    ),
    GoRoute(
      path: PATH_INTERPROVINCE_RIDE,
      builder: (context, state) => InterprovinceRidePage(),
    ),
    GoRoute(
      path: PATH_BOOK_FOR_FAMILY,
      builder: (context, state) => BookForFamilyPage(),
    ),
    GoRoute(
      path: PATH_RENT_DRIVER,
      builder: (context, state) => RentDriverPage(),
    ),
    GoRoute(
      path: PATH_FINDING_DRIVER,
      builder: (context, state) {
        final path = state.extra as String;

        return FindingDriverPage(path: path);
      },
    ),
    GoRoute(
      path: PATH_WAITING_DRIVER,
      builder: (context, state) => WaitingDriverPage(),
    ),
    GoRoute(
      path: PATH_TRIP_DETAIL,
      builder: (context, state) => TripDetailPage(),
    ),
    // food
    // GoRoute(
    //   path: PATH_FOOD_INTRO,
    //   builder: (context, state) => FoodIntroPage(),
    // ),
    GoRoute(
      path: PATH_FOOD,
      builder: (context, state) => FoodDeliveryPage(),
    ),
    GoRoute(
      path: PATH_CART,
      builder: (context, state) => CartPage(),
    ),

    GoRoute(
      path: PATH_CHECKOUT,
      builder: (context, state) => CheckoutPage(),
    ),
    GoRoute(
      path: PATH_ORDER_TRACKING,
      builder: (context, state) => OrderTrackingPage(),
    ),

    //shipping
    GoRoute(
      path: PATH_SHIPPING,
      builder: (context, state) => ShippingPage(),
    ),
    GoRoute(
      path: PATH_DELIVERY_INFO,
      builder: (context, state) => DeliveryInfoPage(),
    ),
    GoRoute(
      path: PATH_ACTIVITY_TRIP_DETAIL,
      builder: (context, state) => ActivityTripDetailPage(),
    ),
// DRIVER
    GoRoute(
      path: PATH_DRIVER_MAIN,
      builder: (context, state) => DriverPage(),
    ),
    GoRoute(
      path: PATH_RATE_TRIP,
      builder: (context, state) => RateTripPage(),
    ),
    GoRoute(
      path: PATH_MAP_SAMPLE,
      builder: (context, state) => MyHomePage(
        title: "test",
      ),
    ),
    GoRoute(
      path: PATH_DRIVER_MEMBERSHIP,
      builder: (context, state) => MembershipPage(),
    ),
    GoRoute(
      path: PATH_DRIVER_TOPUP,
      builder: (context, state) => TopUpPage(),
    ),
    GoRoute(
      path: PATH_PAYMENT_SUCCESS,
      builder: (context, state) => PaymentSuccessPage(),
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
