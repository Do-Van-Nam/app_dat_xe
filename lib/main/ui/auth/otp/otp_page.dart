import 'package:demo_app/res/app_colors.dart';
import 'package:demo_app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'otp_bloc.dart';

class OtpPage extends StatelessWidget {
  final String phoneNumber; // Ví dụ: "+84 9xx xxx 123"

  const OtpPage({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OtpBloc(),
      child: OtpView(phoneNumber: phoneNumber),
    );
  }
}

class OtpView extends StatefulWidget {
  final String phoneNumber;

  const OtpView({super.key, required this.phoneNumber});

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

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
    print('value: $value');
    print('otpCode.length: ${otpCode.length}');
    print('otpCode: $otpCode');
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
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
                  'Chúng tôi đã gửi mã xác thực 6 số đến số điện thoại\n${widget.phoneNumber}',
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
                        listenWhen: (previous, current) =>
                            previous != current &&
                            current
                                is OtpSuccess, // chỉ lắng nghe khi thành công
                        listener: (context, state) {
                          if (state is OtpSuccess) {
                            context.push(PATH_RESET_PASSWORD, extra: otpCode);
                          }
                        },
                        child: BlocBuilder<OtpBloc, OtpState>(
                          builder: (context, state) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(6, (index) {
                                return Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    // width: 44,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: state is OtpInvalid &&
                                                otpCode.length == 6
                                            ? Colors.red
                                            : Colors.transparent,
                                      ),
                                    ),
                                    child: TextField(
                                      controller: _controllers[index],
                                      focusNode: _focusNodes[index],
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      maxLength: 1,
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
                          final canResend = state is OtpResendAvailable;
                          return GestureDetector(
                            onTap: canResend
                                ? () {
                                    context
                                        .read<OtpBloc>()
                                        .add(ResendOtpRequested());
                                  }
                                : null,
                            child: Text(
                              canResend ? 'Gửi lại mã' : 'Gửi lại mã (30s)',
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
                    final isLoading = state is OtpVerifying;
                    final isEnabled = otpCode.length == 6 && !isLoading;

                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isEnabled
                            ? () {
                                context.read<OtpBloc>().add(
                                      VerifyOtpSubmitted(otp: otpCode),
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
                        child: isLoading
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
