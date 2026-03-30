import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  Timer? _resendTimer;
  int _remainingSeconds = 30;

  OtpBloc() : super(OtpInitial()) {
    on<OtpChanged>(_onOtpChanged);
    on<VerifyOtpSubmitted>(_onVerifyOtp);
    on<ResendOtpRequested>(_onResendOtp);
  }

  void _onOtpChanged(OtpChanged event, Emitter<OtpState> emit) {
    if (state is OtpInvalid) {
      emit(OtpInitial());
    }
  }

  Future<void> _onVerifyOtp(
      VerifyOtpSubmitted event, Emitter<OtpState> emit) async {
    emit(OtpVerifying());

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (event.otp == "123456") {
        // Giả lập OTP đúng
        emit(OtpSuccess());
      } else {
        emit(OtpInvalid('Mã OTP không đúng. Vui lòng thử lại.'));
      }
    } catch (e) {
      emit(OtpInvalid('Xác thực thất bại. Vui lòng thử lại.'));
    }
  }

  void _onResendOtp(ResendOtpRequested event, Emitter<OtpState> emit) {
    emit(OtpResendCooldown(30));
    _remainingSeconds = 30;

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingSeconds--;

      if (_remainingSeconds <= 0) {
        timer.cancel();
        emit(OtpResendAvailable());
      } else {
        emit(OtpResendCooldown(_remainingSeconds));
      }
    });
  }

  @override
  Future<void> close() {
    _resendTimer?.cancel();
    return super.close();
  }
}
