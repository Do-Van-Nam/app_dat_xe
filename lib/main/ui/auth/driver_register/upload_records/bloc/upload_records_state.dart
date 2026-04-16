part of 'upload_records_bloc.dart';

enum UploadRecordsDocStatus { pending, uploading, verified, error }

enum UploadRecordsDocActionType { upload, camera }

class UploadRecordsDocItem extends Equatable {
  const UploadRecordsDocItem({
    required this.id,
    required this.name,
    required this.subLabel,
    required this.iconPath,
    required this.actionType,
    this.status = UploadRecordsDocStatus.pending,
    this.filePath,
  });

  final String id;
  final String name;
  final String subLabel;
  final String iconPath;
  final UploadRecordsDocActionType actionType;
  final UploadRecordsDocStatus status;
  final XFile? filePath;

  bool get isVerified => status == UploadRecordsDocStatus.verified;
  bool get isUploading => status == UploadRecordsDocStatus.uploading;

  UploadRecordsDocItem copyWith({
    UploadRecordsDocStatus? status,
    XFile? filePath,
  }) {
    return UploadRecordsDocItem(
      id: id,
      name: name,
      subLabel: subLabel,
      iconPath: iconPath,
      actionType: actionType,
      status: status ?? this.status,
      filePath: filePath ?? this.filePath,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, subLabel, iconPath, actionType, status, filePath];
}

enum UploadRecordsPageStatus { initial, submitting, submitted, error }

class UploadRecordsState extends Equatable {
  const UploadRecordsState({
    this.pageStatus = UploadRecordsPageStatus.initial,
    this.documents = const [],
    this.info,
    this.errorMessage,
  });

  final UploadRecordsPageStatus pageStatus;
  final List<UploadRecordsDocItem> documents;
  final UploadRecordsInfo? info;
  final String? errorMessage;

  int get totalRequired => documents.length;
  int get completedCount => documents.where((d) => d.isVerified).length;
  bool get canProceed => completedCount == totalRequired;

  UploadRecordsState copyWith({
    UploadRecordsPageStatus? pageStatus,
    List<UploadRecordsDocItem>? documents,
    UploadRecordsInfo? info,
    String? errorMessage,
  }) {
    return UploadRecordsState(
      pageStatus: pageStatus ?? this.pageStatus,
      documents: documents ?? this.documents,
      info: info ?? this.info,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [pageStatus, documents, info, errorMessage];
}

class UploadRecordsInfo extends Equatable {
  const UploadRecordsInfo({
    required this.cccd,
    required this.vehicleType,
    required this.vehicleName,
    required this.vehicleColor,
    required this.vehicleNumber,
    required this.vehicleYear,
  });

  final String cccd;
  final int vehicleType;
  final String vehicleName;
  final int vehicleColor;
  final String vehicleNumber;
  final int vehicleYear;

  UploadRecordsInfo copyWith({
    String? cccd,
    int? vehicleType,
    String? vehicleName,
    int? vehicleColor,
    String? vehicleNumber,
    int? vehicleYear,
  }) {
    return UploadRecordsInfo(
      cccd: cccd ?? this.cccd,
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleName: vehicleName ?? this.vehicleName,
      vehicleColor: vehicleColor ?? this.vehicleColor,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      vehicleYear: vehicleYear ?? this.vehicleYear,
    );
  }

  @override
  List<Object?> get props => [
        cccd,
        vehicleType,
        vehicleName,
        vehicleColor,
        vehicleNumber,
        vehicleYear
      ];
}
