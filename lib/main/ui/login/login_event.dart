import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class SignUpEvent extends LoginEvent{
  final String phoneNumber;
  final bool confirmOtp;
  final String otp;
  SignUpEvent(this.phoneNumber, this.confirmOtp, this.otp);
}