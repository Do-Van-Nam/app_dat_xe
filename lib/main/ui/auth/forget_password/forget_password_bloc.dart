import 'package:flutter_bloc/flutter_bloc.dart';
part 'forget_password_event.dart';
part 'forget_password_state.dart';

class ForgetPasswordBloc
    extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  ForgetPasswordBloc() : super(ForgetPasswordInitial()) {
    on<SendOtpRequested>(_onSendOtpRequested);
  }

  Future<void> _onSendOtpRequested(
      SendOtpRequested event, Emitter<ForgetPasswordState> emit) async {
    emit(ForgetPasswordLoading());

    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      if (event.phone.isEmpty || event.phone.length < 9) {
        emit(ForgetPasswordFailure('Vui lòng nhập số điện thoại hợp lệ'));
        return;
      }

      // Giả lập thành công → chuyển sang màn OTP
      emit(ForgetPasswordSuccess(event.phone));
    } catch (e) {
      emit(ForgetPasswordFailure('Có lỗi xảy ra. Vui lòng thử lại.'));
    }
  }
}
