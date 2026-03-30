part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent {}

class LoadProfileEvent extends EditProfileEvent {}

class UpdateProfileEvent extends EditProfileEvent {
  final String fullName;
  final String phone;
  final String email;
  final String birthDate;
  final String gender;

  UpdateProfileEvent({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.birthDate,
    required this.gender,
  });
}

class GenderChangedEvent extends EditProfileEvent {
  final String gender;
  GenderChangedEvent(this.gender);
}
