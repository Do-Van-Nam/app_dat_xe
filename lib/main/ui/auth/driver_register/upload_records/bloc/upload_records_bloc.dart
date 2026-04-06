import 'package:bloc/bloc.dart';
import 'package:demo_app/res/app_images.dart';
import 'package:equatable/equatable.dart';

part 'upload_records_event.dart';
part 'upload_records_state.dart';

class UploadRecordsBloc extends Bloc<UploadRecordsEvent, UploadRecordsState> {
  UploadRecordsBloc() : super(const UploadRecordsState()) {
    on<UploadRecordsInitialised>(_onInitialised);
    on<UploadRecordsUploadTapped>(_onUploadTapped);
    on<UploadRecordsCameraTapped>(_onCameraTapped);
    on<UploadRecordsFileSelected>(_onFileSelected);
    on<UploadRecordsDocVerified>(_onDocVerified);
    on<UploadRecordsDocFailed>(_onDocFailed);
    on<UploadRecordsNextTapped>(_onNextTapped);

    add(const UploadRecordsInitialised());
  }

  void _onInitialised(
    UploadRecordsInitialised event,
    Emitter<UploadRecordsState> emit,
  ) {
    emit(state.copyWith(
      documents: [
        const UploadRecordsDocItem(
          id: 'cccd',
          name: 'CCCD (2 mặt)',
          subLabel: 'YÊU CẦU BẢN GỐC',
          iconPath: AppImages.icIdCard,
          actionType: UploadRecordsDocActionType.upload,
        ),
        UploadRecordsDocItem(
          id: 'license',
          name: 'Bằng lái xe',
          subLabel: 'ĐÃ XÁC MINH',
          iconPath: AppImages.icDriverLicense,
          actionType: UploadRecordsDocActionType.upload,
          status: UploadRecordsDocStatus.verified, // pre-verified in design
        ),
        const UploadRecordsDocItem(
          id: 'car_reg',
          name: 'Cà vẹt xe',
          subLabel: 'ĐĂNG KÝ CHÍNH CHỦ',
          iconPath: AppImages.icCarRegistration,
          actionType: UploadRecordsDocActionType.upload,
        ),
        const UploadRecordsDocItem(
          id: 'avatar',
          name: 'Ảnh chân dung',
          subLabel: 'NHẬN DIỆN\nKHUÔN MẶT',
          iconPath: AppImages.icFaceId,
          actionType: UploadRecordsDocActionType.camera,
        ),
      ],
    ));
  }

  void _onUploadTapped(
    UploadRecordsUploadTapped event,
    Emitter<UploadRecordsState> emit,
  ) {
    // TODO: open file picker, then dispatch UploadRecordsFileSelected
  }

  void _onCameraTapped(
    UploadRecordsCameraTapped event,
    Emitter<UploadRecordsState> emit,
  ) {
    // TODO: open camera, then dispatch UploadRecordsFileSelected
  }

  Future<void> _onFileSelected(
    UploadRecordsFileSelected event,
    Emitter<UploadRecordsState> emit,
  ) async {
    final updated = state.documents.map((d) {
      if (d.id == event.docId) {
        return d.copyWith(
          status: UploadRecordsDocStatus.uploading,
          filePath: event.filePath,
        );
      }
      return d;
    }).toList();
    emit(state.copyWith(documents: updated));

    try {
      // TODO: call repository to upload & verify document
      await Future.delayed(const Duration(seconds: 2));
      add(UploadRecordsDocVerified(event.docId));
    } catch (e) {
      add(UploadRecordsDocFailed(docId: event.docId, message: e.toString()));
    }
  }

  void _onDocVerified(
    UploadRecordsDocVerified event,
    Emitter<UploadRecordsState> emit,
  ) {
    final updated = state.documents.map((d) {
      if (d.id == event.docId) {
        return d.copyWith(status: UploadRecordsDocStatus.verified);
      }
      return d;
    }).toList();
    emit(state.copyWith(documents: updated));
  }

  void _onDocFailed(
    UploadRecordsDocFailed event,
    Emitter<UploadRecordsState> emit,
  ) {
    final updated = state.documents.map((d) {
      if (d.id == event.docId) {
        return d.copyWith(status: UploadRecordsDocStatus.error);
      }
      return d;
    }).toList();
    emit(state.copyWith(
      documents: updated,
      errorMessage: event.message,
    ));
  }

  Future<void> _onNextTapped(
    UploadRecordsNextTapped event,
    Emitter<UploadRecordsState> emit,
  ) async {
    if (!state.canProceed) return;
    emit(state.copyWith(pageStatus: UploadRecordsPageStatus.submitting));
    try {
      // TODO: submit verification to backend
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(pageStatus: UploadRecordsPageStatus.submitted));
    } catch (e) {
      emit(state.copyWith(
        pageStatus: UploadRecordsPageStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
