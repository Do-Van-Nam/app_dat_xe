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
  final String? filePath;

  bool get isVerified => status == UploadRecordsDocStatus.verified;
  bool get isUploading => status == UploadRecordsDocStatus.uploading;

  UploadRecordsDocItem copyWith({
    UploadRecordsDocStatus? status,
    String? filePath,
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
    this.errorMessage,
  });

  final UploadRecordsPageStatus pageStatus;
  final List<UploadRecordsDocItem> documents;
  final String? errorMessage;

  int get totalRequired => documents.length;
  int get completedCount => documents.where((d) => d.isVerified).length;
  bool get canProceed => completedCount == totalRequired;

  UploadRecordsState copyWith({
    UploadRecordsPageStatus? pageStatus,
    List<UploadRecordsDocItem>? documents,
    String? errorMessage,
  }) {
    return UploadRecordsState(
      pageStatus: pageStatus ?? this.pageStatus,
      documents: documents ?? this.documents,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [pageStatus, documents, errorMessage];
}
