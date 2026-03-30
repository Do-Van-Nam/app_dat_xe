import 'package:flutter_bloc/flutter_bloc.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc() : super(ResetPasswordInitial()) {
    on<ResetPasswordSubmitted>(_onResetPasswordSubmitted);
  }

  Future<void> _onResetPasswordSubmitted(
      ResetPasswordSubmitted event, Emitter<ResetPasswordState> emit) async {
    emit(ResetPasswordLoading());

    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulate API

      if (event.newPassword.length < 8) {
        emit(ResetPasswordFailure('Mật khẩu phải có ít nhất 8 ký tự'));
        return;
      }

      if (event.newPassword != event.confirmPassword) {
        emit(ResetPasswordFailure('Mật khẩu xác nhận không khớp'));
        return;
      }

      emit(ResetPasswordSuccess());
    } catch (e) {
      emit(
          ResetPasswordFailure('Đặt lại mật khẩu thất bại. Vui lòng thử lại.'));
    }
  }
}
