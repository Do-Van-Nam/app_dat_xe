import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'confirm_pickup_event.dart';
import 'confirm_pickup_state.dart';

class ConfirmPickupBloc extends Bloc<ConfirmPickupEvent, ConfirmPickupState> {
  ConfirmPickupBloc() : super(const ConfirmPickupState()) {
    on<TakePhotoEvent>(_onTakePhoto);
    on<TogglePackageCheckedEvent>(_onTogglePackageChecked);
    on<SubmitConfirmPickupEvent>(_onSubmitConfirmPickup);
    on<ConfirmPickupCameraTapped>(_onCameraTapped);
  }

  void _onTakePhoto(TakePhotoEvent event, Emitter<ConfirmPickupState> emit) {
    // Toggle the state or simulate taking photo
    emit(state.copyWith(isPhotoTaken: !state.isPhotoTaken));
  }

  void _onTogglePackageChecked(
      TogglePackageCheckedEvent event, Emitter<ConfirmPickupState> emit) {
    emit(state.copyWith(isPackageChecked: !state.isPackageChecked));
  }

  Future<void> _onSubmitConfirmPickup(
      SubmitConfirmPickupEvent event, Emitter<ConfirmPickupState> emit) async {
    if (!state.isPackageChecked || !state.isPhotoTaken) return;
    emit(state.copyWith(status: ConfirmPickupStatus.loading));

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    emit(state.copyWith(status: ConfirmPickupStatus.success));
  }

  Future<void> _onCameraTapped(
    ConfirmPickupCameraTapped event,
    Emitter<ConfirmPickupState> emit,
  ) async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera, // hoặc ImageSource.camera
        imageQuality: 80, // Giảm chất lượng để file nhỏ hơn
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image == null) return;
      // Bước 1: Đọc file thành bytes
      final File imageFile = File(image.path);
      final List<int> imageBytes = await imageFile.readAsBytes();

      // Bước 2: Chuyển sang Base64 String
      final String base64Image = base64Encode(imageBytes);
      print('base64Image: $base64Image');
      emit(state.copyWith(isPhotoTaken: true));

      // add(UploadRecordsFileSelected(docId: event.docId, filePath: image));
    } catch (e) {
      print(e);
    }
    // TODO: open camera, then dispatch UploadRecordsFileSelected
  }
}
