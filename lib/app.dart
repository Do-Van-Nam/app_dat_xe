import 'dart:async';

import 'package:demo_app/config/app_config.dart';
import 'package:demo_app/generated/app_localizations.dart';
import 'package:demo_app/main/ui/language/language_bloc.dart';
import 'package:demo_app/main/ui/language/language_event.dart';
import 'package:demo_app/main/ui/language/languge_state.dart';
import 'package:demo_app/main/utils/device_utils.dart';
import 'package:demo_app/main/utils/logger.dart';
import 'package:demo_app/main/utils/service/deeplink_service.dart';
import 'package:demo_app/main/utils/service/navigation_handler.dart';
import 'package:demo_app/res/app_theme.dart';
import 'package:demo_app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'main/ui/splash/splash_bloc.dart';
import 'main/ui/splash/splash_event.dart';

class App extends StatefulWidget {
final AppConfig config;
  const App({super.key,required this.config});
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initDeeplinks();
    });
    // Load device info in background (non-blocking)
    unawaited(DeviceUtils.getDeviceInfo());
  }

  void _initDeeplinks() {
    // Deeplink init is synchronous, no await needed
    DeeplinkService().init(
      onDeepLink: (Uri uri) {
        AppLogger().logInfo("Deeplink received: $uri");
        try {
          // Delegate handling to central navigation handler (queues until ready)
          NavigationHandler.instance.handleDeepLink(uri);
        } catch (e, st) {
          AppLogger().logError("Handle deeplink error: $e\n$st");
        }
      },
    );
  }

  @override
  void dispose() {
    DeeplinkService().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LanguageBloc()..add(LoadLanguageEvent())),
        BlocProvider(create: (_) => SplashBloc()),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, languageState) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, child) {
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: appSystemUiOverlayStyle,
                child: MaterialApp.router(
                  title: widget.config.appName,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: ThemeMode.system,
                  debugShowCheckedModeBanner: false,
                  locale: languageState.locale,
                  supportedLocales: const [
                    Locale("en"),
                    Locale("vi"),
                    Locale("km"),
                  ],
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    AppLocalizations.delegate,
                  ],
                  routerConfig: router,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
