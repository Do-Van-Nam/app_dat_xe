import 'package:demo_app/main/data/model/user/user.dart';
import 'package:demo_app/main/data/repository/auth_repository.dart';
import 'package:demo_app/main/data/repository/user_repository.dart';
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
      final (isSuccess, user) = await UserRepository().getUserProfile();
      if (isSuccess) {
        print("user: ${user?.toJson()}");
        print("emit success");
        emit(EditProfileLoaded(user: user!));
      } else {
        print("emit error");
        emit(EditProfileError("Không thể tải thông tin cá nhân"));
      }
    } catch (e) {
      print("emit error");
      emit(EditProfileError("Không thể tải thông tin cá nhân"));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfileEvent event, Emitter<EditProfileState> emit) async {
    emit(EditProfileUpdating());
    try {
      final (isSuccess, user) = await UserRepository().updateUserProfile(
        {
          'full_name': event.fullName,
          'phone': event.phone,
          'email': event.email,
          'birthday': event.birthDate,
          'gender': event.gender == "Nam"
              ? 1
              : event.gender == "Nữ"
                  ? 2
                  : 3,
        },
      );
      if (event.currentPassword.isNotEmpty && event.newPassword.isNotEmpty) {
        final (isSuccessChangePassword, messageChangePassword) =
            await UserRepository().changePassword(
          currentPassword: event.currentPassword,
          newPassword: event.newPassword,
          newPasswordConfirmation: event.newPassword,
        );
        if (isSuccessChangePassword) {
          print("emit success change password");
          // emit(EditProfileSuccess());
        } else {
          print("emit error change password");
          emit(UpdateProfileError(
              messageChangePassword ?? "Cập nhật thất bại. Vui lòng thử lại!"));
          return;
        }
      }
      if (isSuccess) {
        if (user == null) {
          // yeu cau otp goi api lay otp sau do chuyen sang man otp
          print("emit need otp");
          final (isSuccess, message) = await AuthRepository()
              .requestOtp(phone: "${event.oldPhone}", type: 4);

          if (isSuccess) {
            emit(EditProfileNeedOtp());
          } else {
            emit(UpdateProfileError(
                message.isNotEmpty ? message : 'Cập nhật thất bại'));
          }
        } else {
          print("emit success");
          emit(EditProfileSuccess());
        }
      } else {
        print("emit error");
        emit(UpdateProfileError("Cập nhật thất bại. Vui lòng thử lại!"));
      }
    } catch (e) {
      print("emit error catch");
      emit(UpdateProfileError("Cập nhật thất bại. Vui lòng thử lại!"));
    }
  }

  void _onGenderChanged(
      GenderChangedEvent event, Emitter<EditProfileState> emit) {
    if (state is EditProfileLoaded) {
      final current = state as EditProfileLoaded;
      emit(EditProfileLoaded(
        // user: current.user.copyWith(gender: event.gender),
        user: current.user,
      ));
    }
  }
}
