import 'package:demo_app/main/base/base_response.dart';
import 'package:demo_app/main/data/api/api_end_point.dart';
import 'package:demo_app/main/data/api/api_util.dart';
import 'package:demo_app/main/data/response/sign_in_response.dart';
import 'package:demo_app/main/ui/login_otp/login_otp_event.dart';
import 'package:demo_app/main/ui/login_otp/login_otp_state.dart';
import 'package:demo_app/main/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginOTPBloc extends Bloc<LoginOTPEvent, LoginOTPState> {
  LoginOTPBloc() : super(LoginOTPInitial()) {
    on<GenerateOTPEvent>(_onGenerateOTP);
    on<SignInEvent>(_onSignIn);
    on<GetUserInfoEvent>(_onGetUserInfo);
  }

  Future<void> _onGenerateOTP(GenerateOTPEvent event, Emitter<LoginOTPState> emit) async {
    Map<String, dynamic> body = {
      "apiKey": "",
      "sessionId": "",
      "username": "",
      "wsCode": "",
      "wsRequest": {
        "phone_number": event.phoneNumber,
      }
    };

    try {
      BaseResponse result = await ApiUtil.getInstance()!.post(
        url: ApiEndPoint.DOMAIN_API,
        body: body,
      );

      if (result.isSuccess) {
        emit(GenerateOTPSuccess(result.message ?? ""));
      } else {
        emit(GenerateOTPFailure(result.message ?? "Fail"));
      }
    } catch (e) {
      emit(GenerateOTPFailure("Network error: ${e.toString()}"));
      AppLogger().logInfo("Network error: ${e.toString()}");
    }
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<LoginOTPState> emit) async {
    emit(SignInLoading());

    Map<String, dynamic> body = {
      "apiKey": "",
      "sessionId": "",
      "username": "",
      "wsCode": "",
      "wsRequest": {
        "appCode": "MyVTG",
        "device": "000229163ad3286e",
        "otp": event.otp,
        "phone_number": event.phoneNumber,
        "prefix": "855",
        "type": "otp",
      }
    };

    try {
      BaseResponse result = await ApiUtil.getInstance()!.post(
        url: ApiEndPoint.DOMAIN_API,
        body: body,
      );

      SignInResponse signInResponse = SignInResponse.fromJson(result.data ?? {});

      if (signInResponse.isSuccess && signInResponse.signInData != null) {
        emit(SignInSuccess(signInResponse.message ?? "", signInResponse.signInData!));
      } else {
        emit(SignInFailure(signInResponse.message ?? "Failed"));
      }
    } catch (e) {
      emit(SignInFailure("Network error: ${e.toString()}"));
    }
  }

  Future<void> _onGetUserInfo(GetUserInfoEvent event, Emitter<LoginOTPState> emit) async {
    Map<String, dynamic> headers = {
      "Authorization": event.token,
    };

    try {
      BaseResponse result = await ApiUtil.getInstance()!.get(
        url: ApiEndPoint.DOMAIN_API,
        headers: headers,
      );

      // // UserInfoResponse? userInfo;
      // if (result.isSuccess && result.data != null) {
      //   // userInfo = UserInfoResponse.fromJson(result.data);
      // }

      // if (result.isSuccess && userInfo != null) {
      //   emit(GetUserInfoSuccess(
      //     result.message ?? "",
      //     userInfo.user,
      //     userInfo.services,
      //     userInfo.imageKyc,
      //   ));
      // } else {
      //   emit(GetUserInfoFailure(result.message ?? "Fail"));
      // }
    } catch (e) {
      emit(GetUserInfoFailure("Network error: ${e.toString()}"));
    }
  }
}