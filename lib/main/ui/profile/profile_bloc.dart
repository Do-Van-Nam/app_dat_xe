import 'dart:async';

import 'package:demo_app/main/data/model/user/user.dart';
import 'package:demo_app/main/data/repository/auth_repository.dart';
import 'package:demo_app/main/data/repository/user_repository.dart';
import 'package:demo_app/main/data/service/socket_service/driver_socket_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  late StreamSubscription _sub;

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<LogoutEvent>(_onLogout);
    on<ChangePaymentMethodEvent>(_onChangePaymentMethod);
  }

  Future<void> _onLoadProfile(
      LoadProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final (isSuccess, user) = await UserRepository().getUserProfile();
      if (isSuccess) {
        print("user: ${user?.toJson()}");
        emit(ProfileLoaded(user: user!, isCredit: true));
      } else {
        emit(ProfileError("Không thể tải thông tin cá nhân"));
      }
    } catch (e) {
      emit(ProfileError("Không thể tải thông tin cá nhân"));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final (isSuccess, message) = await AuthRepository().logout();
      if (isSuccess) {
        emit(ProfileLoggedOut());
        // UserSocketService().disconnect();
        DriverSocketService().disconnect();
      } else {
        emit(ProfileError(message.isNotEmpty ? message : 'Đăng xuất thất bại'));
        // UserSocketService().disconnect();
        // DriverSocketService().disconnect();
        // // emit(ProfileError(message.isNotEmpty ? message : 'Đăng xuất thất bại'));
        // emit(ProfileLoggedOut());
      }
    } catch (e) {
      // UserSocketService().disconnect();
      // DriverSocketService().disconnect();
      // emit(ProfileLoggedOut());
      emit(ProfileError('Đăng xuất thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onChangePaymentMethod(
      ChangePaymentMethodEvent event, Emitter<ProfileState> emit) async {
    emit((state as ProfileLoaded).copyWith(isCredit: event.isCredit));
  }
}
