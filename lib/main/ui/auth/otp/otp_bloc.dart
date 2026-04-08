import 'dart:async';
import 'package:demo_app/main/data/repository/auth_repository.dart';
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
    if (event.otp.length == 6) {
      emit(OtpFullLength());
    } else {
      emit(OtpInitial());
    }
  }

  Future<void> _onVerifyOtp(
      VerifyOtpSubmitted event, Emitter<OtpState> emit) async {
    emit(OtpVerifying());

    try {
      print("goi api");
      final (isSuccess, message) = await AuthRepository().register(
        phone: "0${event.phone}",
        fullName: event.fullName,
        password: event.password,
        otp: event.otp,
      );
      print("goi api $isSuccess");

      if (isSuccess) {
        emit(OtpSuccess());
      } else {
        emit(OtpInvalid(message.isNotEmpty ? message : 'Đăng ký thất bại'));
      }
    } catch (e) {
      emit(OtpInvalid('Đăng ký thất bại: ${e.toString()}'));
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
