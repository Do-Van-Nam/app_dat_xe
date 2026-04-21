part of 'upload_records_bloc.dart';

abstract class UploadRecordsEvent extends Equatable {
  const UploadRecordsEvent();

  @override
  List<Object?> get props => [];
}

/// Page initialised – seed document list.
class UploadRecordsInitialised extends UploadRecordsEvent {
  const UploadRecordsInitialised();
}

/// User taps "Tải lên" on a document item.
class UploadRecordsUploadTapped extends UploadRecordsEvent {
  const UploadRecordsUploadTapped(this.docId);
  final String docId;

  @override
  List<Object?> get props => [docId];
}

/// User taps "Chụp ảnh" on a document item.
class UploadRecordsCameraTapped extends UploadRecordsEvent {
  const UploadRecordsCameraTapped(this.docId);
  final String docId;

  @override
  List<Object?> get props => [docId];
}

/// File picked / captured from device.
class UploadRecordsFileSelected extends UploadRecordsEvent {
  const UploadRecordsFileSelected(
      {required this.docId, required this.filePath});
  final String docId;
  final XFile filePath;

  @override
  List<Object?> get props => [docId, filePath];
}

/// Upload / verify completed for a document.
class UploadRecordsDocVerified extends UploadRecordsEvent {
  const UploadRecordsDocVerified(this.docId);
  final String docId;

  @override
  List<Object?> get props => [docId];
}

/// Upload failed for a document.
class UploadRecordsDocFailed extends UploadRecordsEvent {
  const UploadRecordsDocFailed({required this.docId, required this.message});
  final String docId;
  final String message;

  @override
  List<Object?> get props => [docId, message];
}

class UploadRecordsInfoChanged extends UploadRecordsEvent {
  const UploadRecordsInfoChanged({
    required this.type,
    required this.value,
  });

  final String type;
  final String value;

  @override
  List<Object?> get props => [
        type,
        value,
      ];
}

/// User taps "Bước tiếp theo".
class UploadRecordsNextTapped extends UploadRecordsEvent {
  const UploadRecordsNextTapped();

  @override
  List<Object?> get props => [];
}
