part of 'otp_bloc.dart';

abstract class OtpEvent {}

class OtpChanged extends OtpEvent {
  final String otp;
  OtpChanged(this.otp);
}

class VerifyOtpSubmitted extends OtpEvent {
  final String otp;
  final String phone;
  final String fullName;
  final String password;
  VerifyOtpSubmitted({
    required this.otp,
    required this.phone,
    required this.fullName,
    required this.password,
  });
}

class ResendOtpRequested extends OtpEvent {}
