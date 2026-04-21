part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final User user;
  final bool isCredit;

  ProfileLoaded({
    required this.user,
    required this.isCredit,
  });

  ProfileLoaded copyWith({
    User? user,
    bool? isCredit,
  }) {
    return ProfileLoaded(
      user: user ?? this.user,
      isCredit: isCredit ?? this.isCredit,
    );
  }
}

final class ProfileLoading extends ProfileState {}

final class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

final class ProfileLoggedOut extends ProfileState {}
