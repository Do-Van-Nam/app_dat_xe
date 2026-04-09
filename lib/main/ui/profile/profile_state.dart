part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final User user;

  ProfileLoaded({
    required this.user,
  });
}

final class ProfileLoading extends ProfileState {}

final class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

final class ProfileLoggedOut extends ProfileState {}
