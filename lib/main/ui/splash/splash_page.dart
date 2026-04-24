import 'package:demo_app/main/ui/splash/splash_event.dart';
import 'package:demo_app/main/utils/constant.dart';
import 'package:demo_app/router.dart';
import 'package:demo_app/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../utils/service/navigation_handler.dart';
import 'splash_bloc.dart';
import 'splash_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashBloc>().add(SplashStarted());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashResolved) {
// Sử dụng SchedulerBinding để đảm bảo navigation không block animation
          SchedulerBinding.instance.addPostFrameCallback((_) {
            switch (state.next) {
              case SplashNext.home:
                context.go(PATH_HOME);
                break;
              case SplashNext.login:
                context.go(PATH_LOGIN);
                break;
              case SplashNext.forceUpdate:
                context.go(PATH_CHATBOT);
                break;
              case SplashNext.maintenance:
                context.go(PATH_CHATBOT);
                break;
            }

// App is ready for queued navigation (deeplink/notification).
            NavigationHandler.instance.markReady();
          });
        }
      },
      child: const Scaffold(
        body: RepaintBoundary(child: Center(child: _SplashLoadingIndicator())),
      ),
    );
  }
}

class _SplashLoadingIndicator extends StatelessWidget {
  const _SplashLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    // CircularProgressIndicator đã có animation sẵn, không cần AnimationController
    // Sử dụng const để tối ưu performance
    return const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(AppColors.color_E11B),
      strokeWidth: 3.0,
    );
  }
}
