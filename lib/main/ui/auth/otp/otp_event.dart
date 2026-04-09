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
  final String type;
  VerifyOtpSubmitted({
    required this.otp,
    required this.phone,
    required this.fullName,
    required this.password,
    required this.type,
  });
}

class ResendOtpRequested extends OtpEvent {}
