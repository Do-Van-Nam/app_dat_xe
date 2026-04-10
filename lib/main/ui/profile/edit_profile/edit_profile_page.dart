import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/generated/app_localizations.dart';
import 'package:demo_app/main/data/model/user/user.dart';
import 'package:demo_app/main/utils/widget/app_toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'edit_profile_bloc.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _birthDateController;
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  String _selectedGender = "Nam";
  User? _loadedUser; // Lưu lại user đã load để form không bị mất khi có lỗi

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _birthDateController = TextEditingController();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    // Parse existing date if available
    if (_birthDateController.text.isNotEmpty) {
      try {
        final parts = _birthDateController.text.split('/');
        if (parts.length == 3) {
          initialDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } catch (_) {}
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Chọn ngày sinh',
      cancelText: 'Hủy',
      confirmText: 'Chọn',
    );

    if (picked != null) {
      print("picked: $picked");
      final formatted =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      setState(() {
        print("formatted: $formatted");
        _birthDateController.text = formatted;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => EditProfileBloc()..add(LoadProfileEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.editInformation),
          leading: const BackButton(),
        ),
        body: BlocConsumer<EditProfileBloc, EditProfileState>(
          listener: (context, state) {
            if (state is EditProfileSuccess) {
              AppToast.show(context, l10n.updateSuccess);
            } else if (state is UpdateProfileError) {
              AppToast.show(context, state.message);
            } else if (state is EditProfileNeedOtp) {
              AppToast.show(
                  context, "Vui lòng xác thực OTP để cập nhật thông tin");
              context.push(PATH_VERIFY_OTP, extra: {
                "phone": _phoneController.text,
                "type": "update_info"
              });
            }
          },
          builder: (context, state) {
            if (state is EditProfileLoading && _loadedUser == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is EditProfileLoaded) {
              // Chỉ gán giá trị ban đầu, không ghi đè khi người dùng đã chỉnh sửa
              final User user = state.user;
              _loadedUser = user; // Cache lại user
              // luu so dien thoai cu :
              final String oldPhone = user.phone;
              if (_nameController.text.isEmpty) {
                _nameController.text = user.fullName?.value ?? "";
              }
              if (_phoneController.text.isEmpty) {
                _phoneController.text = user.phone;
              }
              if (_emailController.text.isEmpty) {
                _emailController.text = user.email ?? "";
              }
              if (_birthDateController.text.isEmpty) {
                _birthDateController.text = user.birthday ?? "";
              }
              if (_selectedGender == "Nam" &&
                  user.gender?.value != null &&
                  user.gender?.value != 1) {
                _selectedGender = user.gender?.value == 2 ? "Nữ" : "Khác";
              }

              return _buildForm(context, state, user, oldPhone);
            }

            // Render form khi đã có user (kể cả khi đang update hoặc có lỗi)
            if (_loadedUser != null) {
              String oldPhone = _loadedUser!.phone;
              return _buildForm(context, state, _loadedUser!, oldPhone);
            }

            return const Center(child: Text("Đã xảy ra lỗi"));
          },
        ),
      ),
    );
  }

  // Tách form ra method riêng để tái sử dụng
  Widget _buildForm(BuildContext context, EditProfileState state, User user,
      String oldPhone) {
    final l10n = AppLocalizations.of(context)!;
    final isUpdating = state is EditProfileUpdating;

    return Column(
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, size: 70, color: Colors.grey),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Chọn ảnh đại diện")),
                            );
                          },
                          child: const CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.camera_alt,
                                size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.yourAvatar,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 32),

                  _buildTextField(context,
                      label: l10n.fullName,
                      controller: _nameController,
                      hint: "Nguyễn Minh Anh"),
                  const SizedBox(height: 20),

                  _buildTextField(context,
                      label: l10n.phoneNumber,
                      controller: _phoneController,
                      hint: "090 123 4567",
                      keyboardType: TextInputType.phone,
                      suffix: user.isPhoneVerified
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: ShapeDecoration(
                                color: const Color(0x4C69FF87),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(AppImages.icVerified,
                                      width: 13, height: 13),
                                  const SizedBox(width: 4),
                                  Text(l10n.verified,
                                      style: AppStyles.inter14Bold.copyWith(
                                          color: Colors.green, fontSize: 10)),
                                ],
                              ),
                            )
                          : null),
                  const SizedBox(height: 20),

                  _buildTextField(context,
                      label: l10n.email,
                      controller: _emailController,
                      hint: "Chưa cập nhật",
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 20),

                  _buildTextField(context,
                      label: l10n.dateOfBirth,
                      controller: _birthDateController,
                      hint: "Chưa cập nhật",
                      readOnly: true,
                      suffix: GestureDetector(
                        onTap: () => _selectDate(context),
                        child: const Icon(Icons.calendar_today,
                            color: Colors.grey, size: 20),
                      ),
                      onTap: () => _selectDate(context)),
                  const SizedBox(height: 20),

                  // Giới tính
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.gender,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: AppColors.color_E2E2E5,
                        ),
                        items: ["Nam", "Nữ", "Khác"]
                            .map((g) =>
                                DropdownMenuItem(value: g, child: Text(g)))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedGender = value);
                            context
                                .read<EditProfileBloc>()
                                .add(GenderChangedEvent(value));
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(context,
                      label: 'Mật khẩu hiện tại',
                      controller: _currentPasswordController,
                      hint: 'Nhập mật khẩu hiện tại',
                      obscureText: _obscureCurrentPassword,
                      suffix: GestureDetector(
                        onTap: () => setState(() =>
                            _obscureCurrentPassword = !_obscureCurrentPassword),
                        child: Icon(
                            _obscureCurrentPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                            size: 20),
                      ),
                      isRequired: false),
                  const SizedBox(height: 20),

                  _buildTextField(context,
                      label: 'Mật khẩu mới',
                      controller: _newPasswordController,
                      hint: 'Nhập mật khẩu mới',
                      obscureText: _obscureNewPassword,
                      suffix: GestureDetector(
                        onTap: () => setState(
                            () => _obscureNewPassword = !_obscureNewPassword),
                        child: Icon(
                            _obscureNewPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                            size: 20),
                      ),
                      isRequired: false),
                  const SizedBox(height: 40),

                  // Nút Lưu
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          height: 90,
          child: ElevatedButton(
            onPressed: isUpdating
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      context.read<EditProfileBloc>().add(
                            UpdateProfileEvent(
                              fullName: _nameController.text,
                              phone: _phoneController.text,
                              oldPhone: oldPhone,
                              email: _emailController.text,
                              birthDate: _birthDateController.text,
                              gender: _selectedGender,
                              currentPassword: _currentPasswordController.text,
                              newPassword: _newPasswordController.text,
                            ),
                          );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.colorMain,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: isUpdating
                ? const CircularProgressIndicator(color: Colors.white)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.save, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(l10n.saveChanges,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    Widget? suffix,
    bool readOnly = false,
    bool obscureText = false,
    bool isRequired = true,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          obscureText: obscureText,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: AppColors.color_E2E2E5,
            suffix: suffix,
          ),
          validator: (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return "Vui lòng nhập thông tin";
            }
            return null;
          },
        ),
      ],
    );
  }
}
