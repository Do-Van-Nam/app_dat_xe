
import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class SignUpLoading extends LoginState {}

class SignUpSuccess extends LoginState {
  final String message;

  SignUpSuccess(this.message);
}

class SignUpFailure extends LoginState {
  final String message;

  SignUpFailure(this.message);
}