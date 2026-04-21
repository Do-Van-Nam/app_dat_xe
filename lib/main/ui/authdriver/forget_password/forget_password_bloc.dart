import 'package:demo_app/main/data/repository/auth_repository.dart';
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
      if (event.phone.isEmpty) {
        emit(ForgetPasswordFailure('Vui lòng kiểm tra lại thông tin'));
        return;
      }
      final (isSuccess, message) =
          await AuthRepository().requestOtp(phone: "0${event.phone}", type: 3);
      if (isSuccess) {
        emit(ForgetPasswordSuccess(event.phone));
      } else {
        emit(ForgetPasswordFailure(
            message.isNotEmpty ? message : 'Lỗi gửi OTP'));
      }
    } catch (e) {
      emit(ForgetPasswordFailure('Có lỗi xảy ra. Vui lòng thử lại.'));
    }
  }
}
