part of 'reset_password_bloc.dart';

abstract class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {}

class ResetPasswordFailure extends ResetPasswordState {
  final String error;

  ResetPasswordFailure(this.error);
}
