import 'package:demo_app/main/utils/widget/common_widgets.dart';
import 'package:demo_app/res/app_colors.dart';
import 'package:demo_app/res/app_fonts.dart';
import 'package:demo_app/res/app_images.dart';
import 'package:demo_app/res/app_styles.dart';
import 'package:demo_app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'login_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color_F9F9FC,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 60),

              // Logo Truck
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E40AF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.local_shipping_outlined,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Tiêu đề
              Text(
                'Chào mừng trở lại',
                style: AppStyles.headerBlack,
              ),
              Text(
                'NHMSOFTWARE — Mọi lúc, mọi nơi',
                style: AppStyles.inter16Medium,
              ),

              const SizedBox(height: 24),

              // Form
              BlocListener<LoginBloc, LoginState>(
                  listenWhen: (previous, current) =>
                      previous != current &&
                      current is LoginSuccess, // chỉ lắng nghe khi thành công
                  listener: (context, state) {
                    if (state is LoginSuccess) {
                      // Chuyển sang trang Home và xóa stack (không cho quay lại Login)
                      context.go(PATH_HOME); // Dùng .go() tốt hơn .push() ở đây
                    }
                  },
                  child: BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          // Phone Input
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "DANG NHAP TAI KHOAN CUA BAN",
                                  style: AppTextFonts.interBold.copyWith(
                                      fontSize: 12,
                                      color: AppColors.color_434653),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.color_E2E2E5,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          children: [
                                            // Icon(Icons.flag, size: 24),
                                            Image.asset(
                                              AppImages.imgVnFlag,
                                              width: 16,
                                              height: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            const Text(
                                              '+84',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: phoneController,
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            hintText: 'Nhập số điện thoại',
                                            hintStyle: AppStyles.inter16Medium
                                                .copyWith(
                                                    color:
                                                        AppColors.color_737784),
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Password Input
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.color_E2E2E5,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: TextField(
                                    controller: passwordController,
                                    obscureText: _obscurePassword,
                                    decoration: InputDecoration(
                                      hintText: 'Nhập mật khẩu',
                                      hintStyle: AppStyles.inter16Medium
                                          .copyWith(
                                              color: AppColors.color_737784),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 16,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword =
                                                !_obscurePassword;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Login Button
                                commonButton2(
                                    text: "Tiep tuc",
                                    isLoading: state is LoginLoading,
                                    onPressed: () {
                                      context.read<LoginBloc>().add(
                                            LoginSubmitted(
                                              phone:
                                                  phoneController.text.trim(),
                                              password: passwordController.text,
                                            ),
                                          );
                                    }),
                                const SizedBox(height: 32),

                                // Divider
                                const Row(
                                  children: [
                                    Expanded(child: Divider()),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                        'HOẶC ĐĂNG NHẬP BẰNG',
                                        style: TextStyle(
                                            color: AppColors.color_434653),
                                      ),
                                    ),
                                    Expanded(child: Divider()),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                // Social Login
                                Row(
                                  children: [
                                    Expanded(
                                      child: _socialButton(
                                        'Google',
                                        "null",
                                        () {
                                          // TODO: Google Sign In
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _socialButton(
                                        'iOS Apple',
                                        null,
                                        () {
                                          // TODO: Apple Sign In
                                        },
                                        isApple: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Register Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Chưa có tài khoản? '),
                              GestureDetector(
                                onTap: () {
                                  context.push(PATH_SIGNUP);
                                },
                                child: const Text(
                                  'Đăng ký ngay',
                                  style: TextStyle(
                                    color: Color(0xFF1E40AF),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Forgot Password
                          GestureDetector(
                            onTap: () {
                              context.push(PATH_FORGOT_PASSWORD);
                            },
                            child: const Text(
                              'Quên mật khẩu?',
                              style: TextStyle(
                                color: Color(0xFF1E40AF),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),
                        ],
                      );
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialButton(String text, String? iconPath, VoidCallback onTap,
      {bool isApple = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isApple)
              const Icon(Icons.apple, size: 28)
            else if (iconPath != null)
              SvgPicture.asset(AppImages.icGoogle, height: 24),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
