import 'package:demo_app/main/utils/widget/app_toast_widget.dart';
import 'package:demo_app/main/utils/widget/common_widgets.dart';
import 'package:demo_app/res/app_colors.dart';
import 'package:demo_app/res/app_images.dart';
import 'package:demo_app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'signup_bloc.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupBloc(),
      child: const SignupView(),
    );
  }
}

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _agreeToTerms = false;

  void _onInputChanged() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fullNameController.addListener(_onInputChanged);
    phoneController.addListener(_onInputChanged);
    emailController.addListener(_onInputChanged);
    passwordController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    fullNameController.removeListener(_onInputChanged);
    phoneController.removeListener(_onInputChanged);
    emailController.removeListener(_onInputChanged);
    passwordController.removeListener(_onInputChanged);
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
          'Tạo tài khoản mới',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Bắt đầu hành trình\nvận chuyển của bạn',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Điền thông tin bên dưới để trở thành một phần của mạng lưới vận tải thông minh.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              BlocListener<SignupBloc, SignupState>(
                listenWhen: (previous, current) =>
                    previous != current, // chỉ lắng nghe khi thành công
                listener: (context, state) {
                  if (state is SignupSuccess) {
                    context.push(
                      PATH_VERIFY_OTP,
                      extra: {
                        'phone': phoneController.text.trim(),
                        'password': passwordController.text.trim(),
                        'fullName': fullNameController.text.trim(),
                        'type': "signup",
                      },
                    );
                    // AppToast.show(context, "Đăng ký thành công");
                  } else if (state is SignupFailure) {
                    AppToast.show(context, state.errorMessage);
                  }
                },
                child: BlocBuilder<SignupBloc, SignupState>(
                  builder: (context, state) {
                    return Column(
                      children: [
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
                            children: [
                              // Họ và tên
                              buildTextField(
                                controller: fullNameController,
                                label: 'HỌ VÀ TÊN',
                                hint: 'Nhập họ và tên đầy đủ',
                                icon: Icons.person_outline,
                              ),

                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Số điện thoại",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Số điện thoại
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: AppColors.color_E2E2E5,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      '+84',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: buildTextField(
                                      controller: phoneController,
                                      label: '',
                                      hint: '9xx xxx xxx',
                                      icon: Icons.phone_iphone,
                                      keyboardType: TextInputType.phone,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // Email
                              buildTextField(
                                controller: emailController,
                                label: 'EMAIL',
                                hint: 'example@gmail.com',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                              ),

                              const SizedBox(height: 20),

                              // Mật khẩu
                              _buildPasswordField(),

                              const SizedBox(height: 16),

                              // Checkbox điều khoản
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: _agreeToTerms,
                                    onChanged: (value) {
                                      setState(
                                          () => _agreeToTerms = value ?? false);
                                    },
                                    activeColor: const Color(0xFF1E40AF),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: RichText(
                                        text: const TextSpan(
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14),
                                          children: [
                                            TextSpan(text: 'Tôi đồng ý với '),
                                            TextSpan(
                                              text: 'Điều khoản sử dụng',
                                              style: TextStyle(
                                                color: Color(0xFF1E40AF),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(text: ' và '),
                                            TextSpan(
                                              text: 'Chính sách bảo mật',
                                              style: TextStyle(
                                                color: Color(0xFF1E40AF),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                                text: ' của Logistics Pro.'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 32),

                              // Nút Đăng ký
                              Builder(builder: (context) {
                                final bool isFormValid = _agreeToTerms &&
                                    phoneController.text.trim().isNotEmpty &&
                                    emailController.text.trim().isNotEmpty &&
                                    passwordController.text.isNotEmpty &&
                                    fullNameController.text.trim().isNotEmpty;

                                return commonButton(
                                  text: 'Đăng ký',
                                  onPressed: (state is SignupLoading ||
                                          !isFormValid)
                                      ? null
                                      : () {
                                          context.read<SignupBloc>().add(
                                                SignupSubmitted(
                                                  fullName: fullNameController
                                                      .text
                                                      .trim(),
                                                  phone: phoneController.text
                                                      .trim(),
                                                  email: emailController.text
                                                      .trim(),
                                                  password:
                                                      passwordController.text,
                                                ),
                                              );
                                        },
                                  disable: !isFormValid,
                                  isLoading: state is SignupLoading,
                                );
                              }),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Hoặc kết nối qua
                        const Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'HOẶC KẾT NỐI QUA',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Google & Apple
                        Row(
                          children: [
                            Expanded(
                              child: _socialButton(
                                  'Google', Icons.g_mobiledata, Colors.red),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _socialButton(
                                  'Apple', Icons.apple, Colors.black),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // Đã có tài khoản?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Đã có tài khoản? '),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Text(
                                'Đăng nhập',
                                style: TextStyle(
                                  color: Color(0xFF1E40AF),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'MẬT KHẨU',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.color_E2E2E5,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
              hintText: 'Tối thiểu 8 ký tự',
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _socialButton(String text, IconData icon, Color color) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          text == "Google"
              ? SvgPicture.asset(AppImages.icGoogle, height: 24)
              : Icon(icon, size: 28, color: color),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
