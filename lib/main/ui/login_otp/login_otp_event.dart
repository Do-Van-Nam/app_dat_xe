import 'package:equatable/equatable.dart';

abstract class LoginOTPEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class GenerateOTPEvent extends LoginOTPEvent {
  final String phoneNumber;

  GenerateOTPEvent(this.phoneNumber);
}

class SignInEvent extends LoginOTPEvent {
  final String phoneNumber;
  final String otp;

  SignInEvent(this.phoneNumber, this.otp);

  @override
  List<Object> get props => [phoneNumber, otp];
}

class GetUserInfoEvent extends LoginOTPEvent {
  final String token;

  GetUserInfoEvent(this.token);
}