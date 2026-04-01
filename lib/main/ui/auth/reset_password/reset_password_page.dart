import 'package:demo_app/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'reset_password_bloc.dart';

class ResetPasswordPage extends StatelessWidget {
  final String phoneNumber; // Nhận từ màn OTP

  const ResetPasswordPage({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordBloc(),
      child: ResetPasswordView(phoneNumber: phoneNumber),
    );
  }
}

class ResetPasswordView extends StatefulWidget {
  final String phoneNumber;

  const ResetPasswordView({super.key, required this.phoneNumber});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _passwordsMatch = true;

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePasswords() {
    setState(() {
      _passwordsMatch =
          newPasswordController.text == confirmPasswordController.text;
    });
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
        title: const Text(
          'Đặt lại mật khẩu',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.lock_reset,
                  size: 32,
                  color: Color(0xFF1E40AF),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Đặt lại mật khẩu mới',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),
              const Text.rich(
                TextSpan(
                  text:
                      'Vui lòng nhập mật khẩu mới để tiếp tục sử dụng dịch vụ của ',
                  style:
                      TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
                  children: [
                    TextSpan(
                      text: 'NHM SOFTWARE.',
                      style: TextStyle(
                        color: Color(0xFF1E40AF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
                builder: (context, state) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.color_F3F3F6,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // Mật khẩu mới
                        _buildPasswordField(
                          controller: newPasswordController,
                          label: 'Mật khẩu mới',
                          obscureText: _obscureNewPassword,
                          onVisibilityToggle: () {
                            setState(() =>
                                _obscureNewPassword = !_obscureNewPassword);
                          },
                          onChanged: (_) => _validatePasswords(),
                        ),

                        const SizedBox(height: 20),

                        // Xác nhận mật khẩu mới
                        _buildPasswordField(
                          controller: confirmPasswordController,
                          label: 'Xác nhận mật khẩu mới',
                          obscureText: _obscureConfirmPassword,
                          onVisibilityToggle: () {
                            setState(() => _obscureConfirmPassword =
                                !_obscureConfirmPassword);
                          },
                          onChanged: (_) => _validatePasswords(),
                          showError: !_passwordsMatch &&
                              confirmPasswordController.text.isNotEmpty,
                        ),

                        const SizedBox(height: 16),

                        // Password Requirement Box
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.info_outline,
                                      size: 20, color: Colors.grey),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        text: 'Mật khẩu phải có ít nhất ',
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                        children: const [
                                          TextSpan(
                                            text: '8 ký tự',
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          TextSpan(
                                            text: ', bao gồm ',
                                          ),
                                          TextSpan(
                                            text: 'chữ hoa, chữ thường',
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          TextSpan(
                                            text: ' và ',
                                          ),
                                          TextSpan(
                                            text: 'số',
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          TextSpan(
                                            text: '.',
                                          ),
                                        ],
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                          height: 4, color: Colors.green)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Container(
                                          height: 4, color: Colors.green)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Container(
                                          height: 4, color: Colors.grey[300])),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Xác nhận button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: (state is ResetPasswordLoading ||
                                    newPasswordController.text.isEmpty ||
                                    confirmPasswordController.text.isEmpty ||
                                    !_passwordsMatch)
                                ? null
                                : () {
                                    context.read<ResetPasswordBloc>().add(
                                          ResetPasswordSubmitted(
                                            newPassword:
                                                newPasswordController.text,
                                            confirmPassword:
                                                confirmPasswordController.text,
                                          ),
                                        );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E40AF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: state is ResetPasswordLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text(
                                    'Xác nhận đổi mật khẩu →',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              // Support Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0EA5E9),
                        shape: BoxShape.circle,
                      ),
                      child:
                          const Icon(Icons.support_agent, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CẦN HỖ TRỢ?',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Liên hệ hỗ trợ',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.headset_mic_outlined,
                        color: Color(0xFF1E40AF)),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onVisibilityToggle,
    required Function(String) onChanged,
    bool showError = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.color_E2E2E5,
            borderRadius: BorderRadius.circular(12),
            border: showError ? Border.all(color: Colors.red) : null,
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            onChanged: onChanged,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              suffixIcon: IconButton(
                icon:
                    Icon(obscureText ? Icons.visibility_off : Icons.visibility),
                onPressed: onVisibilityToggle,
              ),
            ),
          ),
        ),
        if (showError)
          const Padding(
            padding: EdgeInsets.only(top: 4, left: 4),
            child: Text(
              'Mật khẩu xác nhận không khớp',
              style: TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
      ],
    );
  }
}
