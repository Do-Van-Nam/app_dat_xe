part of 'reset_password_bloc.dart';

abstract class ResetPasswordEvent {}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  final String newPassword;
  final String confirmPassword;
  final String phone;
  final String otp;

  ResetPasswordSubmitted({
    required this.newPassword,
    required this.confirmPassword,
    required this.phone,
    required this.otp,
  });
}
