import 'package:demo_app/main/data/repository/auth_repository.dart';
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
      if (event.newPassword.length < 8) {
        emit(ResetPasswordFailure('Mật khẩu phải có ít nhất 8 ký tự'));
        return;
      }

      if (event.newPassword != event.confirmPassword) {
        emit(ResetPasswordFailure('Mật khẩu xác nhận không khớp'));
        return;
      }
      final (isSuccess, message) = await AuthRepository().resetPassword(
        phone: "0${event.phone}",
        password: event.newPassword,
        otp: event.otp,
      );
      print("goi api $isSuccess");

      if (isSuccess) {
        emit(ResetPasswordSuccess());
      } else {
        emit(ResetPasswordFailure(
            message.isNotEmpty ? message : 'Đặt lại mật khẩu thất bại'));
      }
    } catch (e) {
      emit(
          ResetPasswordFailure('Đặt lại mật khẩu thất bại. Vui lòng thử lại.'));
    }
  }
}
