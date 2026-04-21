part of 'signup_bloc.dart';

abstract class SignupEvent {}

class SignupSubmitted extends SignupEvent {
  final String fullName;
  final String phone;
  final String email;
  final String password;

  SignupSubmitted({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.password,
  });
}
