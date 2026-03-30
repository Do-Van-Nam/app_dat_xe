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
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (event.fullName.isEmpty ||
          event.phone.isEmpty ||
          event.password.length < 8) {
        emit(SignupFailure('Vui lòng kiểm tra lại thông tin'));
        return;
      }

      // Giả lập đăng ký thành công
      emit(SignupSuccess());
    } catch (e) {
      emit(SignupFailure('Đăng ký thất bại: ${e.toString()}'));
    }
  }
}
