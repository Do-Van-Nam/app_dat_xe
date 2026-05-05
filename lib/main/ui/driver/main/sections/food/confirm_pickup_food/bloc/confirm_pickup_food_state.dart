import 'package:equatable/equatable.dart';

enum ConfirmPickupFoodStatus { initial, loading, success, failure }

class ConfirmPickupFoodState extends Equatable {
  final ConfirmPickupFoodStatus status;
  final bool isPhotoTaken;

  const ConfirmPickupFoodState({
    this.status = ConfirmPickupFoodStatus.initial,
    this.isPhotoTaken = false,
  });

  ConfirmPickupFoodState copyWith({
    ConfirmPickupFoodStatus? status,
    bool? isPhotoTaken,
  }) {
    return ConfirmPickupFoodState(
      status: status ?? this.status,
      isPhotoTaken: isPhotoTaken ?? this.isPhotoTaken,
    );
  }

  @override
  List<Object?> get props => [status, isPhotoTaken];
}
