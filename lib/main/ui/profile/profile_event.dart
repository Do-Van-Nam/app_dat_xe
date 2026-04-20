part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {}

class ChangePaymentMethodEvent extends ProfileEvent {
  final bool isCredit;
  ChangePaymentMethodEvent({required this.isCredit});
}

class LogoutEvent extends ProfileEvent {}
