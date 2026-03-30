import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(EditProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<GenderChangedEvent>(_onGenderChanged);
  }

  Future<void> _onLoadProfile(
      LoadProfileEvent event, Emitter<EditProfileState> emit) async {
    emit(EditProfileLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 600));

      emit(EditProfileLoaded(
        fullName: "Nguyễn Minh Anh",
        phone: "090 123 4567",
        email: "minhanh.nguyen@example.com",
        birthDate: "05/20/1995",
        gender: "Nam",
      ));
    } catch (e) {
      emit(EditProfileError("Không thể tải thông tin"));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfileEvent event, Emitter<EditProfileState> emit) async {
    emit(EditProfileUpdating());
    try {
      // Giả lập gọi API cập nhật
      await Future.delayed(const Duration(seconds: 1));
      emit(EditProfileSuccess());
    } catch (e) {
      emit(EditProfileError("Cập nhật thất bại. Vui lòng thử lại!"));
    }
  }

  void _onGenderChanged(
      GenderChangedEvent event, Emitter<EditProfileState> emit) {
    if (state is EditProfileLoaded) {
      final current = state as EditProfileLoaded;
      emit(EditProfileLoaded(
        fullName: current.fullName,
        phone: current.phone,
        email: current.email,
        birthDate: current.birthDate,
        gender: event.gender,
        isPhoneVerified: current.isPhoneVerified,
      ));
    }
  }
}
