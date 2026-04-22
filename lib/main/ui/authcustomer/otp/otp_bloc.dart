import 'dart:async';
import 'package:demo_app/main/data/repository/auth_repository.dart';
import 'package:demo_app/main/data/repository/user_repository.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  Timer? _resendTimer;
  int _remainingSeconds = 60;

  OtpBloc() : super(OtpLoaded(remainingSeconds: 60)) {
    on<OtpChanged>(_onOtpChanged);
    on<VerifyOtpSubmitted>(_onVerifyOtp);
    on<ResendOtpRequested>(_onResendOtp);
    on<_OtpTimerTick>(_onTimerTick);
  }

  OtpLoaded get _currentLoaded =>
      state is OtpLoaded ? state as OtpLoaded : OtpLoaded();

  void _onOtpChanged(OtpChanged event, Emitter<OtpState> emit) {
    final isFullLength = event.otp.length == 6;
    emit(_currentLoaded.copyWith(
      otpFullLength: isFullLength,
      // Reset lỗi khi người dùng chỉnh sửa OTP
      otpInvalid: false,
    ));
  }

  Future<void> _onVerifyOtp(
      VerifyOtpSubmitted event, Emitter<OtpState> emit) async {
    emit(_currentLoaded.copyWith(otpVerifying: true));

    try {
      if (event.type == "forget") {
        final otpCode = await SharePreferenceUtil.getOtpCode();
        if (otpCode == event.otp) {
          emit(OtpForgetSuccess());
        } else {
          emit(_currentLoaded.copyWith(otpVerifying: false, otpInvalid: true));
        }
        return;
      }

      if (event.type == "update_info") {
        final (isSuccess, message) = await UserRepository().verifyProfileOtp(
          sensitiveData: {"phone": event.phone},
          otp: event.otp,
        );
        if (isSuccess) {
          emit(OtpUpdateInfoSuccess());
        } else {
          emit(_currentLoaded.copyWith(otpVerifying: false, otpInvalid: true));
        }
        return;
      }

      final (isSuccess, message) = await AuthRepository().register(
        phone: "0${event.phone}",
        fullName: event.fullName,
        password: event.password,
        otp: event.otp,
      );

      if (isSuccess) {
        emit(OtpSuccess());
      } else {
        emit(_currentLoaded.copyWith(otpVerifying: false, otpInvalid: true));
      }
    } catch (e) {
      emit(_currentLoaded.copyWith(otpVerifying: false, otpInvalid: true));
    }
  }

  Future<void> _onResendOtp(
      ResendOtpRequested event, Emitter<OtpState> emit) async {
    if (!event.isFirstTime) {
      try {
        final type = event.type == "update_info"
            ? 4
            : event.type == "forget"
                ? 3
                : 1;
        final (isSuccess, message) = await AuthRepository()
            .requestOtp(phone: "0${event.phone}", type: type);
        if (isSuccess) {
          emit(_currentLoaded.copyWith(
              otpVerifying: false, resendOtpFailed: false));
        } else {
          emit(_currentLoaded.copyWith(
              otpVerifying: false, resendOtpFailed: true));
          return;
        }
      } catch (e) {
        emit(_currentLoaded.copyWith(
            otpVerifying: false, resendOtpFailed: true));
        return;
      }
    }

    _resendTimer?.cancel();
    _remainingSeconds = 60;
    emit(_currentLoaded.copyWith(
      remainingSeconds: _remainingSeconds,
      otpInvalid: false,
    ));

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingSeconds--;
      if (!isClosed) {
        add(_OtpTimerTick(_remainingSeconds));
      }
      if (_remainingSeconds <= 0) {
        timer.cancel();
      }
    });
    return;
  }

  void _onTimerTick(_OtpTimerTick event, Emitter<OtpState> emit) {
    emit(_currentLoaded.copyWith(remainingSeconds: event.remainingSeconds));
  }

  @override
  Future<void> close() {
    _resendTimer?.cancel();
    return super.close();
  }
}
