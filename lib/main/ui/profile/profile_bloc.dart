import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLoadProfile(
      LoadProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      // Giả lập load dữ liệu (bạn có thể thay bằng API thật)
      await Future.delayed(const Duration(milliseconds: 800));

      emit(ProfileLoaded(
        name: "Nguyễn Minh Tuấn",
        phone: "090 123 4567",
        avatarUrl:
            "https://example.com/avatar.jpg", // Thay bằng link avatar thật hoặc asset
        points: 1150,
        vouchers: 12,
        membership: "THÀNH VIÊN VÀNG",
      ));
    } catch (e) {
      emit(ProfileError("Không thể tải thông tin cá nhân"));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    // Xử lý logout thật (clear token, prefs, ...)
    await Future.delayed(const Duration(milliseconds: 500));
    emit(ProfileLoggedOut());
  }
}
