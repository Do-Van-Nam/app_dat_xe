part of 'otp_bloc.dart';

abstract class OtpEvent {}

class OtpChanged extends OtpEvent {
  final String otp;
  OtpChanged(this.otp);
}

class VerifyOtpSubmitted extends OtpEvent {
  final String otp;
  VerifyOtpSubmitted({required this.otp});
}

class ResendOtpRequested extends OtpEvent {}
