import 'dart:async';

import 'package:demo_app/generated/app_localizations.dart';
import 'package:demo_app/main/data/model/sign_in_model.dart';
import 'package:demo_app/main/data/model/user_info_model.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:demo_app/main/ui/login/login_bloc.dart';
import 'package:demo_app/main/ui/login/login_event.dart';
import 'package:demo_app/main/ui/login/login_state.dart';
import 'package:demo_app/main/utils/app_config.dart';
import 'package:demo_app/main/utils/widget/app_toast_widget.dart';
import 'package:demo_app/main/utils/widget/loading_overlay_widget.dart';
import 'package:demo_app/res/app_colors.dart';
import 'package:demo_app/res/app_fonts.dart';
import 'package:demo_app/res/app_images.dart';
import 'package:demo_app/res/app_styles.dart';
import 'package:demo_app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) => handleBlocListener(context, state),
          builder: (context, state) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.asset(AppImages.imgBgLogin, fit: BoxFit.cover),
                  ),
                  Positioned.fill(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(12, 110, 12, 12),
                      child: Column(
                        children: [
                          Image.asset(AppImages.imgLogoLogin, width: 143),
                          const SizedBox(height: 12),
                          Text(
                            AppLocalizations.of(context)!.login_des,
                            style: AppTextFonts.poppinsMedium.copyWith(
                              color: AppColors.color_FFFF,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 34),

                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppColors.color_FFFF,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.phone_number,
                                    style: AppTextFonts.poppinsMedium.copyWith(
                                      color: AppColors.color_8588,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.color_5F5F,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: TextField(
                                      controller: phoneController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: AppLocalizations.of(
                                          context,
                                        )!.enter_your_phone_number,
                                        hintStyle: AppTextFonts.poppinsMedium
                                            .copyWith(
                                              color: AppColors.color_8588,
                                              fontSize: 14,
                                            ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        handleLoginPressed(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.color_E11B,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!.login,
                                        style: AppStyles.textButtonWhite,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Center(
                                    child: redLightButton(
                                      title: AppLocalizations.of(context)!.skip,
                                      onTap: () {
                                        _onSkip();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget redLightButton({required VoidCallback onTap, required String title}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 6, 6, 6),
        decoration: BoxDecoration(
          color: AppColors.color_E11B_10,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppTextFonts.poppinsRegular.copyWith(
                color: AppColors.color_E11B,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 2),
            SvgPicture.asset(AppImages.icArrowRightRed),
          ],
        ),
      ),
    );
  }

  void handleLoginPressed(BuildContext context) {
    final bloc = context.read<LoginBloc>();
    if (isValidCambodiaPhone(phoneController.text)) {
      LoadingOverlayWidget.show(context);
      bloc.add(SignUpEvent(phoneController.text, false, "123456"));
    } else {
      AppToast.show(context, AppLocalizations.of(context)!.phone_number_is_not_valid);
    }
  }

  Future<void> handleBlocListener(
    BuildContext context,
    LoginState state,
  ) async {
    if (state is SignUpSuccess) {
      LoadingOverlayWidget.hide();
      context.push(PATH_LOGIN_OTP, extra: phoneController.text);
    }
    if (state is SignUpFailure) {
      LoadingOverlayWidget.hide();
      AppToast.show(context, state.message);
    }
  }

  Future<void> _onSkip() async {
    await SharePreferenceUtil.setBool(ShareKey.KEY_FIRST_OPEN_APP, true);
    if (!mounted) return;
    context.go(PATH_HOME);
  }

  bool isValidCambodiaPhone(String phone) {
    return (phone.startsWith('+855') || phone.startsWith('0')) &&
        phone.length >= 9 &&
        phone.length <= 14;
  }
}
