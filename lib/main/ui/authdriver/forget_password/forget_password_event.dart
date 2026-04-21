part of 'forget_password_bloc.dart';

abstract class ForgetPasswordEvent {}

class SendOtpRequested extends ForgetPasswordEvent {
  final String phone;

  SendOtpRequested({required this.phone});
}
