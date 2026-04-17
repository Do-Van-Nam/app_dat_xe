import 'dart:async';

import 'package:demo_app/main/data/model/user/user.dart';
import 'package:demo_app/main/data/repository/auth_repository.dart';
import 'package:demo_app/main/data/repository/user_repository.dart';
import 'package:demo_app/main/data/service/socket_service/user_socket_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  late StreamSubscription _sub;

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<LogoutEvent>(_onLogout);

    _sub = UserSocketService().onRideEvent.listen((data) {
      // if(data["event"] == "DRIVER_FOUND"){
      //   add(const FindingDriverFound());
      // }
      print("data tu user socket service $data");
    });
  }

  Future<void> _onLoadProfile(
      LoadProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final (isSuccess, user) = await UserRepository().getUserProfile();
      if (isSuccess) {
        print("user: ${user?.toJson()}");
        emit(ProfileLoaded(user: user!));
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
      } else {
        // emit(ProfileError(message.isNotEmpty ? message : 'Đăng xuất thất bại'));
        emit(ProfileLoggedOut());
      }
    } catch (e) {
      emit(ProfileLoggedOut());
      // emit(ProfileError('Đăng xuất thất bại: ${e.toString()}'));
    }
  }
}
