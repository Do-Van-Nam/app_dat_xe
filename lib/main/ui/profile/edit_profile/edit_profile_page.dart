import 'package:demo_app/generated/app_localizations.dart';
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

  String _selectedGender = "Nam";

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _birthDateController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    super.dispose();
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.updateSuccess)),
              );
              Navigator.pop(context, true); // Trở về với kết quả thành công
            } else if (state is EditProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is EditProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is EditProfileLoaded) {
              // Cập nhật giá trị controller
              _nameController.text = state.fullName;
              _phoneController.text = state.phone;
              _emailController.text = state.email;
              _birthDateController.text = state.birthDate;
              _selectedGender = state.gender;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
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
                            child: Icon(Icons.person,
                                size: 70, color: Colors.grey),
                          ),
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                // TODO: Mở picker ảnh
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
                      Text(
                        l10n.yourAvatar,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 32),

                      // Form fields
                      _buildTextField(
                        context,
                        label: l10n.fullName,
                        controller: _nameController,
                        hint: "Nguyễn Minh Anh",
                      ),
                      const SizedBox(height: 20),

                      _buildTextField(
                        context,
                        label: l10n.phoneNumber,
                        controller: _phoneController,
                        hint: "090 123 4567",
                        suffix: state.isPhoneVerified
                            ? Chip(
                                backgroundColor: Colors.green[50],
                                label: Text(
                                  l10n.verified,
                                  style: const TextStyle(color: Colors.green),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 20),

                      _buildTextField(
                        context,
                        label: l10n.email,
                        controller: _emailController,
                        hint: "minhanh.nguyen@example.com",
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),

                      _buildTextField(
                        context,
                        label: l10n.dateOfBirth,
                        controller: _birthDateController,
                        hint: "05/20/1995",
                      ),
                      const SizedBox(height: 20),

                      // Giới tính
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.gender,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedGender,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            items: ["Nam", "Nữ", "Khác"]
                                .map((g) => DropdownMenuItem(
                                      value: g,
                                      child: Text(g),
                                    ))
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
                      const SizedBox(height: 40),

                      // Nút Lưu
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: state is EditProfileUpdating
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<EditProfileBloc>().add(
                                          UpdateProfileEvent(
                                            fullName: _nameController.text,
                                            phone: _phoneController.text,
                                            email: _emailController.text,
                                            birthDate:
                                                _birthDateController.text,
                                            gender: _selectedGender,
                                          ),
                                        );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: state is EditProfileUpdating
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.save, color: Colors.white),
                                    const SizedBox(width: 8),
                                    Text(
                                      l10n.saveChanges,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const Center(child: Text("Đã xảy ra lỗi"));
          },
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    Widget? suffix,
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
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey[100],
            suffix: suffix,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Vui lòng nhập thông tin";
            }
            return null;
          },
        ),
      ],
    );
  }
}
