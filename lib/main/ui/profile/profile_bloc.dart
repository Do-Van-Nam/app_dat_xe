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
            "https://media.gettyimages.com/id/1809004173/photo/natural-pineapple-on-a-tropical-background.jpg?s=612x612&w=gi&k=20&c=MD05PyDnD6-xcnSEgKCuvH8yqk2mUZ5L99PrMoI5OP0=", // Thay bằng link avatar thật hoặc asset
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
