part of 'edit_profile_bloc.dart';

abstract class EditProfileState {}

final class EditProfileInitial extends EditProfileState {}

final class EditProfileLoading extends EditProfileState {}

final class EditProfileLoaded extends EditProfileState {
  final String fullName;
  final String phone;
  final String email;
  final String birthDate;
  final String gender;
  final bool isPhoneVerified;

  EditProfileLoaded({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.birthDate,
    required this.gender,
    this.isPhoneVerified = true,
  });
}

final class EditProfileUpdating extends EditProfileState {}

final class EditProfileSuccess extends EditProfileState {}

final class EditProfileError extends EditProfileState {
  final String message;
  EditProfileError(this.message);
}
