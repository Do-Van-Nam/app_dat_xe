part of 'otp_bloc.dart';

abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpVerifying extends OtpState {}

class OtpSuccess extends OtpState {}

class OtpForgetSuccess extends OtpState {}

class OtpUpdateInfoSuccess extends OtpState {}

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

class OtpLoaded extends OtpState {
  final bool otpFullLength;
  final int remainingSeconds;
  final bool otpInvalid;
  final bool otpVerifying;
  final bool resendOtpFailed;

  OtpLoaded({
    this.otpFullLength = false,
    this.remainingSeconds = 60,
    this.otpInvalid = false,
    this.otpVerifying = false,
    this.resendOtpFailed = false,
  });

  OtpLoaded copyWith({
    bool? otpFullLength,
    int? remainingSeconds,
    bool? otpInvalid,
    bool? otpVerifying,
    bool? resendOtpFailed,
  }) {
    return OtpLoaded(
      otpFullLength: otpFullLength ?? this.otpFullLength,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      otpInvalid: otpInvalid ?? this.otpInvalid,
      otpVerifying: otpVerifying ?? this.otpVerifying,
      resendOtpFailed: resendOtpFailed ?? this.resendOtpFailed,
    );
  }
}
