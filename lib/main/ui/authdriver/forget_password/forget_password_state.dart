part of 'forget_password_bloc.dart';

abstract class ForgetPasswordState {}

class ForgetPasswordInitial extends ForgetPasswordState {}

class ForgetPasswordLoading extends ForgetPasswordState {}

class ForgetPasswordSuccess extends ForgetPasswordState {
  final String phone;
  ForgetPasswordSuccess(this.phone);
}

class ForgetPasswordFailure extends ForgetPasswordState {
  final String error;
  ForgetPasswordFailure(this.error);
}
