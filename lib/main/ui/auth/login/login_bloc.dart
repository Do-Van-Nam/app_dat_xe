import 'package:demo_app/main/data/repository/auth_repository.dart';
import 'package:demo_app/main/data/service/google_sign_in_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginByGoogle>(_onLoginByGoogle);
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      final (isSuccess, message) = await AuthRepository()
          .login(phone: "0${event.phone}", password: event.password);
      if (event.phone.isEmpty || event.password.length < 8) {
        emit(LoginFailure('Vui lòng kiểm tra lại thông tin'));
        return;
      }
      if (isSuccess) {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure(message.isNotEmpty ? message : 'Đăng nhập thất bại'));
      }
    } catch (e) {
      emit(LoginFailure('Đăng nhập thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onLoginByGoogle(
      LoginByGoogle event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      final service = GoogleAuthService();
      // await service
      // .initialize(); // Khởi tạo lần đầu

      final idToken = await service.signInWithGoogle();

      if (idToken != null) {
        print("Đăng nhập thành công: ${idToken}");
        print("Đăng nhập thành công: ${idToken}");
        // context.go(PATH_HOME);
      } else {
        print("Đăng nhập fail");
        // Thông báo lỗi
      }

      // Giả lập đăng nhập thành công
      if (90 >= 9) {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure('Số điện thoại không hợp lệ'));
      }
    } catch (e) {
      emit(LoginFailure('Đăng nhập thất bại: ${e.toString()}'));
    }
  }
}
