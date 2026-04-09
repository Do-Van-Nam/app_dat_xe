import 'package:demo_app/generated/app_localizations.dart';
import 'package:demo_app/main/data/model/user_info_model.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:demo_app/main/utils/widget/app_toast_widget.dart';
import 'package:demo_app/router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppCheck {
  static Future<bool> checkLogin(BuildContext context) async {
    final bool isLoggedIn = UserInfoModel.instance.username.isNotEmpty;
    if (!isLoggedIn) {
      await SharePreferenceUtil.setBool(ShareKey.KEY_FIRST_OPEN_APP, false);
      await SharePreferenceUtil.setBool(ShareKey.KEY_CHANGE_OPEN_APP, true);
      context.go(PATH_LOGIN);
      return false;
    }
    return true;
  }

  static Future<bool> checkInternet(BuildContext context) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      AppToast.show(
          context, AppLocalizations.of(context)!.no_internet_connection);
      return false;
    }
    return true;
  }

  static Future<bool> checkLoginAndInternet(BuildContext context) async {
    final isLoggedIn = await checkLogin(context);
    if (!isLoggedIn) return false;

    final hasInternet = await checkInternet(context);
    if (!hasInternet) return false;

    return true;
  }
}
