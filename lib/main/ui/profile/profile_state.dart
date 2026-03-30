part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final String name;
  final String phone;
  final String avatarUrl;
  final int points;
  final int vouchers;
  final String membership; // "THÀNH VIÊN VÀNG"

  ProfileLoaded({
    required this.name,
    required this.phone,
    required this.avatarUrl,
    required this.points,
    required this.vouchers,
    required this.membership,
  });
}

final class ProfileLoading extends ProfileState {}

final class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

final class ProfileLoggedOut extends ProfileState {}
