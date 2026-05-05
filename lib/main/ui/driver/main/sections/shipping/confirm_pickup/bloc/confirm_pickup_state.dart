import 'package:equatable/equatable.dart';

enum ConfirmPickupStatus { initial, loading, success, failure }

class ConfirmPickupState extends Equatable {
  final ConfirmPickupStatus status;
  final bool isPhotoTaken;
  final bool isPackageChecked;
  
  const ConfirmPickupState({
    this.status = ConfirmPickupStatus.initial,
    this.isPhotoTaken = false,
    this.isPackageChecked = false,
  });

  ConfirmPickupState copyWith({
    ConfirmPickupStatus? status,
    bool? isPhotoTaken,
    bool? isPackageChecked,
  }) {
    return ConfirmPickupState(
      status: status ?? this.status,
      isPhotoTaken: isPhotoTaken ?? this.isPhotoTaken,
      isPackageChecked: isPackageChecked ?? this.isPackageChecked,
    );
  }

  @override
  List<Object?> get props => [status, isPhotoTaken, isPackageChecked];
}
