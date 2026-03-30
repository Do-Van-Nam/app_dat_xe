import 'package:demo_app/main/data/model/sign_in_model.dart';
import 'package:demo_app/main/data/model/user_info_model.dart';
import 'package:equatable/equatable.dart';

abstract class LoginOTPState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoginOTPInitial extends LoginOTPState {}


class GenerateOTPSuccess extends LoginOTPState {
  final String message;

  GenerateOTPSuccess(this.message);
}

class GenerateOTPFailure extends LoginOTPState {
  final String message;

  GenerateOTPFailure(this.message);
}

class SignInLoading extends LoginOTPState {}

class SignInSuccess extends LoginOTPState {
  final String message;
  final SignInModel data;

  SignInSuccess(this.message, this.data);
}

class SignInFailure extends LoginOTPState {
  final String message;

  SignInFailure(this.message);
}

class GetUserInfoSuccess extends LoginOTPState {
  final String message;
  final UserInfoModel? user;


  GetUserInfoSuccess(
      this.message,
      this.user,

      );
}

class GetUserInfoFailure extends LoginOTPState {
  final String message;

  GetUserInfoFailure(this.message);
}