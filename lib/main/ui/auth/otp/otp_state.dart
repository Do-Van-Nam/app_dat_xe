part of 'otp_bloc.dart';

abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpVerifying extends OtpState {}

class OtpSuccess extends OtpState {}

class OtpFullLength extends OtpState {}

class OtpInvalid extends OtpState {
  final String message;
  OtpInvalid(this.message);
}

class OtpResendAvailable extends OtpState {}

class OtpResendCooldown extends OtpState {
  final int remainingSeconds;
  OtpResendCooldown(this.remainingSeconds);
}
