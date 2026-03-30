import 'package:demo_app/main/base/base_response.dart';
import 'package:demo_app/main/data/api/api_end_point.dart';
import 'package:demo_app/main/data/api/api_util.dart';
import 'package:demo_app/main/data/model/sign_in_model.dart';
import 'package:demo_app/main/data/response/sign_in_response.dart';
import 'package:demo_app/main/ui/login/login_event.dart';
import 'package:demo_app/main/ui/login/login_state.dart';
import 'package:demo_app/main/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<SignUpEvent>(_onSignUp);
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<LoginState> emit) async {
    emit(SignUpLoading());
    Map<String, dynamic> body = {
      "apiKey": "",
      "sessionId": "",
      "username": "",
      "wsCode": "",
      "wsRequest": {
        "confirmOtp": event.confirmOtp,
        "otp": event.otp,
        "phone_number": event.phoneNumber,
      }
    };
    try {
      BaseResponse result = await ApiUtil.getInstance()!.post(
        url: ApiEndPoint.DOMAIN_API,
        body: body,
      );

      SignInResponse? signInData;
      if (result.isSuccess && result.data != null) {
        signInData = SignInResponse.fromJson(result.data);
      }
      print("SignUp result: ${result.code} / ${result.message}");
      if (result.isSuccess) {
        emit(SignUpSuccess(result.message ?? ""));
      } else {
        emit(SignUpFailure(result.message ?? "Fail"));
      }
    } catch (e) {
      emit(SignUpFailure("Network error: ${e.toString()}"));
    }
  }
}