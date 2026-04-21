import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:demo_app/main/data/model/user/user.dart';
import 'package:demo_app/main/data/repository/auth_repository.dart';
import 'package:demo_app/main/data/service/driver_register_service.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:demo_app/res/app_images.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

part 'upload_records_event.dart';
part 'upload_records_state.dart';

class UploadRecordsBloc extends Bloc<UploadRecordsEvent, UploadRecordsState> {
  final String phone;
  final String fullName;
  UploadRecordsBloc({required this.phone, required this.fullName})
      : super(const UploadRecordsState()) {
    on<UploadRecordsInitialised>(_onInitialised);
    on<UploadRecordsUploadTapped>(_onUploadTapped);
    on<UploadRecordsCameraTapped>(_onCameraTapped);
    on<UploadRecordsFileSelected>(_onFileSelected);
    on<UploadRecordsDocVerified>(_onDocVerified);
    on<UploadRecordsDocFailed>(_onDocFailed);
    on<UploadRecordsNextTapped>(_onNextTapped);
    on<UploadRecordsInfoChanged>(_onInfoChanged);

    add(const UploadRecordsInitialised());
  }

  void _onInitialised(
    UploadRecordsInitialised event,
    Emitter<UploadRecordsState> emit,
  ) {
    emit(state.copyWith(
      info: const UploadRecordsInfo(
        cccd: '',
        vehicleType: 1,
        vehicleName: '',
        vehicleColor: 0,
        vehicleNumber: '',
        vehicleYear: 0,
      ),
      documents: [
        const UploadRecordsDocItem(
          id: 'cccd_front',
          name: 'CCCD (mặt trước)',
          subLabel: 'YÊU CẦU BẢN GỐC',
          iconPath: AppImages.icIdCard,
          actionType: UploadRecordsDocActionType.upload,
        ),
        const UploadRecordsDocItem(
          id: 'cccd_back',
          name: 'CCCD (mặt sau)',
          subLabel: 'YÊU CẦU BẢN GỐC',
          iconPath: AppImages.icIdCard,
          actionType: UploadRecordsDocActionType.upload,
        ),
        UploadRecordsDocItem(
          id: 'driver_license',
          name: 'Bằng lái xe',
          subLabel: 'ĐÃ XÁC MINH',
          iconPath: AppImages.icDriverLicense,
          actionType: UploadRecordsDocActionType.upload,
        ),
        const UploadRecordsDocItem(
          id: 'vehicle_reg',
          name: 'Đăng ký xe',
          subLabel: 'ĐĂNG KÝ CHÍNH CHỦ',
          iconPath: AppImages.icCarRegistration,
          actionType: UploadRecordsDocActionType.upload,
        ),
        const UploadRecordsDocItem(
          id: 'criminal_record',
          name: 'Lý lịch tư pháp',
          subLabel: 'YÊU CẦU BẢN GỐC',
          iconPath: AppImages.icCarRegistration,
          actionType: UploadRecordsDocActionType.upload,
        ),
        const UploadRecordsDocItem(
          id: 'health_cert',
          name: 'Giấy chứng nhận sức khỏe',
          subLabel: 'YÊU CẦU BẢN GỐC',
          iconPath: AppImages.icCarRegistration,
          actionType: UploadRecordsDocActionType.upload,
        ),
        const UploadRecordsDocItem(
          id: 'portrait',
          name: 'Ảnh chân dung',
          subLabel: 'NHẬN DIỆN\nKHUÔN MẶT',
          iconPath: AppImages.icFaceId,
          actionType: UploadRecordsDocActionType.camera,
        ),
        const UploadRecordsDocItem(
          id: 'insurance',
          name: 'Bảo hiểm xe',
          subLabel: 'YÊU CẦU BẢN GỐC',
          iconPath: AppImages.icCarRegistration,
          actionType: UploadRecordsDocActionType.upload,
        ),
      ],
    ));
  }

  Future<void> _onUploadTapped(
    UploadRecordsUploadTapped event,
    Emitter<UploadRecordsState> emit,
  ) async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery, // hoặc ImageSource.camera
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
      print('docId: ${event.docId}');
      print('base64Image: $base64Image');
      add(UploadRecordsFileSelected(docId: event.docId, filePath: image));
    } catch (e) {
      print(e);
    }

    // final result = await FilePicker.pickFiles();
    // final filePath = result?.files.single.path;
    // if (filePath == null) return;

    // add(UploadRecordsFileSelected(docId: event.docId, filePath: filePath));
  }

  Future<void> _onCameraTapped(
    UploadRecordsCameraTapped event,
    Emitter<UploadRecordsState> emit,
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
      print('docId: ${event.docId}');
      print('base64Image: $base64Image');
      add(UploadRecordsFileSelected(docId: event.docId, filePath: image));
    } catch (e) {
      print(e);
    }
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

  void _onInfoChanged(
    UploadRecordsInfoChanged event,
    Emitter<UploadRecordsState> emit,
  ) {
    final info = state.info?.copyWith(
      cccd: event.type == 'cccd' ? event.value : state.info?.cccd,
      vehicleType: event.type == 'vehicleType'
          ? int.parse(event.value)
          : state.info?.vehicleType,
      vehicleName:
          event.type == 'vehicleName' ? event.value : state.info?.vehicleName,
      vehicleColor: event.type == 'vehicleColor'
          ? int.parse(event.value)
          : state.info?.vehicleColor,
      vehicleNumber: event.type == 'vehicleNumber'
          ? event.value
          : state.info?.vehicleNumber,
      vehicleYear: event.type == 'vehicleYear'
          ? int.parse(event.value.isEmpty ? "0" : event.value)
          : state.info?.vehicleYear,
    );
    emit(state.copyWith(info: info));
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
    print("state.canProceed: ${state.canProceed}");
    if (!state.canProceed) return;
    emit(state.copyWith(pageStatus: UploadRecordsPageStatus.submitting));
    try {
      // final User? user = await SharePreferenceUtil.getUser();
      // final String fullName = user?.fullName?.value ?? '';
      // final String phone = user?.phone ?? '';
      // final (isSuccess, message, data) =
      //     await AuthRepository().submitDriverRegister(body);
      print("phone: ${phone}");
      print("fullName: ${fullName}");
      final String phone1 = phone.length == 9 ? "0$phone" : phone;

      final isSuccess = await DriverRegisterService().registerDriver(
        fullName: fullName,
        phone: phone1,
        citizenId: state.info?.cccd ?? '',
        vehicleType: state.info?.vehicleType ?? 0,
        vehicleName: state.info?.vehicleName ?? '',
        vehicleColor: state.info?.vehicleColor ?? 0,
        vehicleNumber: state.info?.vehicleNumber ?? '',
        vehicleYear: state.info?.vehicleYear ?? 0,
        cccdFront:
            state.documents.firstWhere((d) => d.id == 'cccd_front').filePath ??
                XFile(""),
        cccdBack:
            state.documents.firstWhere((d) => d.id == 'cccd_back').filePath ??
                XFile(""),
        driverLicense: state.documents
                .firstWhere((d) => d.id == 'driver_license')
                .filePath ??
            XFile(""),
        vehicleReg:
            state.documents.firstWhere((d) => d.id == 'vehicle_reg').filePath ??
                XFile(""),
        criminalRecord: state.documents
                .firstWhere((d) => d.id == 'criminal_record')
                .filePath ??
            XFile(""),
        healthCert:
            state.documents.firstWhere((d) => d.id == 'health_cert').filePath ??
                XFile(""),
        portrait:
            state.documents.firstWhere((d) => d.id == 'portrait').filePath ??
                XFile(""),
        insurance:
            state.documents.firstWhere((d) => d.id == 'insurance').filePath ??
                XFile(""),
      );
      if (isSuccess) {
        emit(state.copyWith(pageStatus: UploadRecordsPageStatus.submitted));
      } else {
        // van chuyen trang de test
        // emit(state.copyWith(pageStatus: UploadRecordsPageStatus.submitted));

        emit(state.copyWith(
          pageStatus: UploadRecordsPageStatus.error,
          errorMessage: "Lỗi",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        pageStatus: UploadRecordsPageStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
