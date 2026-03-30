import 'dart:async';

import 'package:demo_app/main/data/model/user_info_model.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:demo_app/main/utils/device_utils.dart';
import 'package:demo_app/main/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/service/local_notification_service.dart';
import '../../utils/service/remote_config_service.dart';
import '../../utils/utility_fuctions.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<SplashStarted>(_onStart);
  }

  Future<void> _onStart(SplashStarted event, Emitter<SplashState> emit) async {
    try {
      emit(SplashLoading());

      // KHÔNG await từng cái - chạy background để không block UI
      unawaited(_initNotifications());

      // Cho UI một frame để render mượt trước khi bắt đầu tác vụ nặng
      await Future.delayed(const Duration(milliseconds: 16));

      /// 1️⃣ Load remote config
      await RemoteConfigService().init();
      final config = RemoteConfigService().config;

      // Cho UI một frame để render mượt
      await Future.delayed(const Duration(milliseconds: 16));

      final currentVersion = await DeviceUtils.getVersionName();

      if (compareVersion(currentVersion, config.minVersion) < 0) {
        emit(SplashResolved(next: SplashNext.forceUpdate, content: "force"));
        return;
      }

      if (compareVersion(currentVersion, config.latestVersion) < 0) {
        emit(SplashResolved(next: SplashNext.forceUpdate));
        return;
      }

      if (config.maintenanceMode) {
        emit(
          SplashResolved(
            next: SplashNext.maintenance,
            content: config.maintenanceMessage,
          ),
        );
        return;
      }

      // Cho UI một frame để render mượt
      await Future.delayed(const Duration(milliseconds: 16));

      /// 3️⃣ Auth
      final isLogin = await _isLoggedIn();
      final isFirstOpenApp = await SharePreferenceUtil.getBool(
        ShareKey.KEY_FIRST_OPEN_APP,
      );
      AppLogger().logInfo("CHECK_LOGIN $isFirstOpenApp");
      emit(
        SplashResolved(
          next: (isLogin || isFirstOpenApp)
              ? SplashNext.home
              : SplashNext.login,
        ),
      );
    } catch (e) {
      /// 3️⃣ Auth
      final isLogin = await _isLoggedIn();
      final isFirstOpenApp = await SharePreferenceUtil.getBool(
        ShareKey.KEY_FIRST_OPEN_APP,
      );
      AppLogger().logInfo("CHECK_LOGIN $isFirstOpenApp");
      emit(
        SplashResolved(
          next: (isLogin || isFirstOpenApp)
              ? SplashNext.home
              : SplashNext.login,
        ),
      );
    }
  }

  Future<bool> _isLoggedIn() async {
    await SharePreferenceUtil.getUser();
    final isLoggedIn = UserInfoModel.instance.username.isNotEmpty;
    return isLoggedIn; // demo
  }

  Future<void> _initNotifications() async {
    try {
      await LocalNotificationService.instance.init();
    } catch (e) {
      AppLogger().logInfo('LocalNotification init error: $e');
    }
  }


}
