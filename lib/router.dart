import 'package:demo_app/main/data/model/user_info_model.dart';
import 'package:demo_app/main/ui/help_center/chatbot/chatbot_intro/chatbot_intro_page.dart';
import 'package:demo_app/main/ui/help_center/chatbot/chatbot_main/chat_page.dart';
import 'package:demo_app/main/ui/language/language_page.dart';
import 'package:demo_app/main/ui/login/login_page.dart';
import 'package:demo_app/main/ui/login_otp/login_otp_page.dart';
import 'package:demo_app/main/ui/main_page.dart';
import 'package:demo_app/main/ui/miniapp/mini_app_bloc.dart';
import 'package:demo_app/main/ui/miniapp/mini_app_overlay.dart';
import 'package:demo_app/main/ui/miniapp/mini_app_state.dart';
import 'package:demo_app/main/utils/app_config.dart';
import 'package:demo_app/main/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'main/ui/splash/splash_page.dart';

const String PATH_SPLASH = "/";
const String PATH_HOME = "/main";
const String PATH_LOGIN = "/login";
const String PATH_LANGUAGE = "/language";

// chatbot
const String PATH_CHATBOT_INTRO = "/chatbot-info";
const String PATH_CHATBOT = "/chatbot";
const String PATH_LOGIN_OTP = "/login_otp";


final GoRouter router = GoRouter(
  initialLocation: PATH_SPLASH,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider(
          create: (_) => MiniAppBloc(),
          child: BlocBuilder<MiniAppBloc, MiniAppState>(
            builder: (context, miniAppState) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Child page - bị che khi webview mở
                  IgnorePointer(
                    ignoring: miniAppState.opened && !miniAppState.minimized,
                    child: child,
                  ),
                  // MiniAppOverlay - luôn ở trên cùng
                  const MiniAppOverlay(), // webview + bubble + close zone
                ],
              );
            },
            buildWhen:
                (previous, current) =>
                    previous.opened != current.opened ||
                    previous.minimized != current.minimized,
          ),
        );
      },
      routes: [
        GoRoute(
          path: PATH_SPLASH,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(path: PATH_HOME, builder: (context, state) => MainPage()),
        GoRoute(path: PATH_LOGIN, builder: (context, state) => LoginPage()),
        GoRoute(
          path: PATH_LANGUAGE,
          builder: (context, state) => LanguagePage(),
        ),

       
        //chat bot
        GoRoute(
          path: PATH_CHATBOT_INTRO,
          builder: (context, state) => ChatbotIntroPage(),
        ),
        GoRoute(
          path: PATH_CHATBOT,
          builder: (context, state) {
            final msg = state.extra as String?;
            return ChatBotPage(initialMessage: msg);
          },
        ), 
        
        
        GoRoute(
          path: PATH_LOGIN_OTP,
          builder: (context, state) {
            final phone = state.extra as String;
            return LoginOTPPage(phone: phone);
          },
        ),
       
      ],
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
