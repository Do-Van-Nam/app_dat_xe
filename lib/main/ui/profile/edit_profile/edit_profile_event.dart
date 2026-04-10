part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent {}

class LoadProfileEvent extends EditProfileEvent {}

class UpdateProfileEvent extends EditProfileEvent {
  final String fullName;
  final String phone;
  final String email;
  final String birthDate;
  String gender;
  final String currentPassword;
  final String newPassword;
  final String oldPhone;

  UpdateProfileEvent({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.birthDate,
    required this.gender,
    required this.currentPassword,
    required this.newPassword,
    required this.oldPhone,
  });
}

class GenderChangedEvent extends EditProfileEvent {
  final String gender;
  GenderChangedEvent(this.gender);
}
