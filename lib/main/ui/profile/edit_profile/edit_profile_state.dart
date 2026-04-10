part of 'edit_profile_bloc.dart';

abstract class EditProfileState {}

final class EditProfileInitial extends EditProfileState {}

final class EditProfileLoading extends EditProfileState {}

final class EditProfileLoaded extends EditProfileState {
  final User user;

  EditProfileLoaded({required this.user});
}

final class EditProfileUpdating extends EditProfileState {}

final class EditProfileNeedOtp extends EditProfileState {}

final class EditProfileSuccess extends EditProfileState {}

final class EditProfileError extends EditProfileState {
  final String message;
  EditProfileError(this.message);
}

final class UpdateProfileError extends EditProfileState {
  final String message;
  UpdateProfileError(this.message);
}
