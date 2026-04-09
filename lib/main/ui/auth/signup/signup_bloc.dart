import 'package:demo_app/main/data/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial()) {
    on<SignupSubmitted>(_onSignupSubmitted);
  }

  Future<void> _onSignupSubmitted(
      SignupSubmitted event, Emitter<SignupState> emit) async {
    emit(SignupLoading());

    try {
      final (isSuccess, message) =
          await AuthRepository().requestOtp(phone: "0${event.phone}", type: 1);
      if (event.fullName.isEmpty ||
          event.phone.isEmpty ||
          event.password.length < 8) {
        emit(SignupFailure('Vui lòng kiểm tra lại thông tin'));
        return;
      }
      if (isSuccess) {
        emit(SignupSuccess());
      } else {
        emit(SignupFailure(message.isNotEmpty ? message : 'Đăng ký thất bại'));
      }
    } catch (e) {
      emit(SignupFailure('Đăng ký thất bại: ${e.toString()}'));
    }
  }
}
