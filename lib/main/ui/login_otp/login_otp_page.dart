import 'dart:async';

import 'package:demo_app/generated/app_localizations.dart';
import 'package:demo_app/main/data/model/sign_in_model.dart';
import 'package:demo_app/main/data/model/user_info_model.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:demo_app/main/ui/login_otp/login_otp_bloc.dart';
import 'package:demo_app/main/ui/login_otp/login_otp_event.dart';
import 'package:demo_app/main/ui/login_otp/login_otp_state.dart';
import 'package:demo_app/main/utils/constant.dart';
import 'package:demo_app/main/utils/logger.dart';
import 'package:demo_app/main/utils/widget/app_toast_widget.dart';
import 'package:demo_app/main/utils/widget/loading_overlay_widget.dart';
import 'package:demo_app/res/app_colors.dart';
import 'package:demo_app/res/app_fonts.dart';
import 'package:demo_app/res/app_styles.dart';
import 'package:demo_app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class LoginOTPPage extends StatefulWidget {
  final String phone;

  const LoginOTPPage({super.key, required this.phone});

  @override
  State<LoginOTPPage> createState() => _LoginOTPPageState();
}

class _LoginOTPPageState extends State<LoginOTPPage> {
  late final LoginOTPBloc _bloc;
  String phone = "";
  final bool isIncorrectOTP = false;
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  Timer? _timer;
  int _secondsRemaining = 90;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _bloc = LoginOTPBloc();
    phone = widget.phone;
    _initData();
    _startCountdown();
  }

  void _startCountdown() {
    _secondsRemaining = 90;
    _canResend = false;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  Future<void> _initData() async {
    _bloc.add(GenerateOTPEvent(phone));
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: AppColors.color_F7F7,
        body: BlocConsumer<LoginOTPBloc, LoginOTPState>(
          builder: (context, state) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: SafeArea(
                      bottom: false,
                      child: SizedBox(
                        height: kToolbarHeight,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios_new,
                                  color: AppColors.color_1618,
                                ),
                                onPressed: () => context.pop(),
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.enter_your_otp,
                              style: AppStyles.headerBlack,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    margin: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      // border: Border.all(
                      //   color: Colors.grey.shade300,
                      // ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.otp_sent_to,
                              style: AppTextFonts.poppinsRegular.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              Constant.normalizePhoneV2(phone),
                              style: AppTextFonts.poppinsSemiBold.copyWith(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        if (isIncorrectOTP) ...[
                          const SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context)!.incorrect_pin_otp,
                            style: AppTextFonts.poppinsRegular.copyWith(
                              fontSize: 12,
                              color: AppColors.color_EF30,
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        PinCodeTextField(
                          appContext: context,
                          length: 6,
                          keyboardType: TextInputType.number,
                          animationType: AnimationType.none,
                          autoFocus: true,
                          textStyle: AppTextFonts.poppinsSemiBold.copyWith(
                            fontSize: 24,
                            color: AppColors.color_1618,
                          ),
                          cursorColor: AppColors.color_EF30,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(12),
                            fieldHeight: 44,
                            fieldWidth: 44,
                            borderWidth: 1.5,
                            activeBorderWidth: 1.5,
                            selectedBorderWidth: 1.5,
                            inactiveBorderWidth: 1.5,
                            activeColor: AppColors.color_EF30,
                            selectedColor: AppColors.color_EF30,
                            inactiveColor: AppColors.color_1618,
                          ),
                          onCompleted: (value) {
                            AppLogger().logInfo('OTP đầy đủ: $value');
                            _bloc.add(SignInEvent(phone, value));
                          },
                          onChanged: (value) {
                            debugPrint('OTP đang nhập: $value');
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.didn_t_otp,
                              style: AppTextFonts.poppinsRegular.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: _canResend
                                  ? () {
                                      _bloc.add(GenerateOTPEvent(phone));
                                      _startCountdown();
                                    }
                                  : null,
                              child: Text(
                                _canResend
                                    ? AppLocalizations.of(context)!.resend_otp
                                    : _timeText,
                                style: AppTextFonts.poppinsMedium.copyWith(
                                  fontSize: 14,
                                  color: AppColors.color_E11B,
                                  decoration: _canResend
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                  decorationColor: AppColors.color_E11B,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          listener: (context, state) {
            if (state is SignInFailure) {
              LoadingOverlayWidget.hide();
              AppToast.show(context, state.message);
            }

            if (state is GetUserInfoFailure) {
              LoadingOverlayWidget.hide();
              AppToast.show(context, state.message);
            }

            if (state is GenerateOTPSuccess || state is GenerateOTPFailure) {
              LoadingOverlayWidget.hide();
            }

            if (state is SignInSuccess) {
              LoadingOverlayWidget.hide();
              _onSaveToken(state.data, _bloc);
            }

            if (state is GetUserInfoSuccess) {
              LoadingOverlayWidget.hide();
              _onSaveUserInfo(state.user);
              context.pushReplacement(PATH_HOME);
            }
          },
        ),
      ),
    );
  }

  String get _timeText {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _onSaveToken(SignInModel model, LoginOTPBloc bloc) async {
    String token = "Bearer ${model.accessToken}";

    await SharePreferenceUtil.setString(ShareKey.KEY_PHONE_NUMBER, phone);
    await SharePreferenceUtil.setString(ShareKey.KEY_ACCESS_TOKEN, token);
    await SharePreferenceUtil.setString(
      ShareKey.KEY_REFRESH_TOKEN,
      model.refreshToken ?? '',
    );

    bloc.add(GetUserInfoEvent(token));
  }

  Future<void> _onSaveUserInfo(UserInfoModel? model) async {
    if (model == null) return;
    await SharePreferenceUtil.saveUser(model);
  }
}
