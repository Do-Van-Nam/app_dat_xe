import 'package:demo_app/main/utils/widget/app_toast_widget.dart';
import 'package:demo_app/res/app_colors.dart';
import 'package:demo_app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'otp_bloc.dart';

class OtpPage extends StatelessWidget {
  final String? phoneNumber; // Ví dụ: "+84 9xx xxx 123"
  final String? password;
  final String? fullName;
  final String type;
  final String? oldPhone;

  const OtpPage({
    super.key,
    this.phoneNumber,
    this.password,
    this.fullName,
    this.type = "forget",
    this.oldPhone,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OtpBloc()
        ..add(ResendOtpRequested(
            phone: type == "update_info" ? oldPhone ?? "0" : phoneNumber ?? "0",
            type: type,
            isFirstTime: true)),
      child: OtpView(
        phoneNumber: phoneNumber,
        password: password,
        fullName: fullName,
        type: type,
        oldPhone: oldPhone,
      ),
    );
  }
}

class OtpView extends StatefulWidget {
  final String? phoneNumber;
  final String? password;
  final String? fullName;
  final String type;
  final String? oldPhone;

  const OtpView({
    super.key,
    this.phoneNumber,
    this.password,
    this.fullName,
    this.type = "forget",
    this.oldPhone,
  });

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (_) => TextEditingController());
    _focusNodes = List.generate(6, (index) {
      final node = FocusNode();
      node.onKeyEvent = (focusNode, event) {
        if (event.logicalKey == LogicalKeyboardKey.backspace &&
            event is KeyDownEvent) {
          if (_controllers[index].text.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
            _controllers[index - 1].clear(); // tuỳ chọn: xoá luôn ô trước đó
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      };

      // Luôn đặt con trỏ ở cuối, tránh di chuyển ra trước
      _controllers[index].addListener(() {
        final text = _controllers[index].text;
        _controllers[index].selection =
            TextSelection.fromPosition(TextPosition(offset: text.length));
      });

      return node;
    });
  }

  String get otpCode => _controllers.map((c) => c.text).join();

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    print('otpCode: $otpCode');
    context.read<OtpBloc>().add(OtpChanged(otpCode));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Icon Lock
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0F2FE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    size: 40,
                    color: Color(0xFF1E40AF),
                  ),
                ),

                const SizedBox(height: 32),

                const Text(
                  'Xác nhận mã OTP',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Chúng tôi đã gửi mã xác thực 6 số đến số điện thoại\n${widget.type == "update_info" ? widget.oldPhone ?? "" : widget.phoneNumber}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),

                const SizedBox(height: 16),

                // OTP Input Fields
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.color_F3F3F6,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      BlocListener<OtpBloc, OtpState>(
                        listenWhen: (previous, current) => previous != current,
                        listener: (context, state) {
                          if (state is OtpSuccess) {
                            AppToast.show(context, 'Đăng ký thành công');
                            context.go(PATH_HOME);
                          }
                          if (state is OtpForgetSuccess) {
                            context.push(PATH_RESET_PASSWORD, extra: {
                              "otpCode": otpCode,
                              "phone": widget.phoneNumber ?? "",
                            });
                          }
                          if (state is OtpUpdateInfoSuccess) {
                            context.go(PATH_PROFILE);
                          }
                          // Hiển thị toast khi OTP sai
                          if (state is OtpLoaded && state.otpInvalid) {
                            AppToast.show(context, 'Mã OTP không chính xác');
                          }
                          if (state is OtpLoaded && state.resendOtpFailed) {
                            AppToast.show(context, 'Gửi lại mã OTP thất bại');
                          }
                        },
                        child: BlocBuilder<OtpBloc, OtpState>(
                          builder: (context, state) {
                            final isInvalid =
                                state is OtpLoaded && state.otpInvalid;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(6, (index) {
                                return Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isInvalid
                                            ? Colors.red
                                            : Colors.transparent,
                                        width: isInvalid ? 1.5 : 1,
                                      ),
                                    ),
                                    child: TextField(
                                      controller: _controllers[index],
                                      focusNode: _focusNodes[index],
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      maxLength: 1,
                                      enableInteractiveSelection: false,
                                      onTap: () {
                                        int targetIndex = 5;
                                        for (int i = 0; i < 6; i++) {
                                          if (_controllers[i].text.isEmpty) {
                                            targetIndex = i;
                                            break;
                                          }
                                        }
                                        if (index != targetIndex) {
                                          _focusNodes[targetIndex]
                                              .requestFocus();
                                        }
                                      },
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: const InputDecoration(
                                        counterText: '',
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (value) =>
                                          _onOtpChanged(index, value),
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Resend OTP
                      Text(
                        'Bạn không nhận được mã?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<OtpBloc, OtpState>(
                        builder: (context, state) {
                          final loaded =
                              state is OtpLoaded ? state : OtpLoaded();
                          final canResend = loaded.remainingSeconds <= 0;
                          return GestureDetector(
                            onTap: canResend
                                ? () => context.read<OtpBloc>().add(
                                    ResendOtpRequested(
                                        phone: widget.type == "update_info"
                                            ? widget.oldPhone ?? "0"
                                            : widget.phoneNumber ?? "0",
                                        type: widget.type,
                                        isFirstTime: false))
                                : null,
                            child: Text(
                              canResend
                                  ? 'Gửi lại mã'
                                  : 'Gửi lại mã (${loaded.remainingSeconds}s)',
                              style: TextStyle(
                                color: canResend
                                    ? const Color(0xFF1E40AF)
                                    : Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                // Tiếp tục Button
                BlocBuilder<OtpBloc, OtpState>(
                  builder: (context, state) {
                    final loaded = state is OtpLoaded ? state : OtpLoaded();
                    final isVerifying = loaded.otpVerifying;
                    final isEnabled = loaded.otpFullLength && !isVerifying;
                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isEnabled
                            ? () {
                                context.read<OtpBloc>().add(
                                      VerifyOtpSubmitted(
                                        otp: otpCode,
                                        phone: widget.phoneNumber ?? "",
                                        fullName: widget.fullName ?? "",
                                        password: widget.password ?? "",
                                        type: widget.type,
                                      ),
                                    );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E40AF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          disabledBackgroundColor: Colors.grey[300],
                        ),
                        child: isVerifying
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                'Tiếp tục',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
