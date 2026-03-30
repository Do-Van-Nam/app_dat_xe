part of 'reset_password_bloc.dart';

abstract class ResetPasswordEvent {}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  final String newPassword;
  final String confirmPassword;

  ResetPasswordSubmitted({
    required this.newPassword,
    required this.confirmPassword,
  });
}
