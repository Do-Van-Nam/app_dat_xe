import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      // TODO: Gọi API đăng nhập thực tế ở đây
      await Future.delayed(const Duration(seconds: 2)); // Simulate network

      if (event.phone.isEmpty || event.password.isEmpty) {
        emit(LoginFailure('Vui lòng nhập đầy đủ thông tin'));
        return;
      }

      // Giả lập đăng nhập thành công
      if (event.phone.length >= 9) {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure('Số điện thoại không hợp lệ'));
      }
    } catch (e) {
      emit(LoginFailure('Đăng nhập thất bại: ${e.toString()}'));
    }
  }
}
