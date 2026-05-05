import 'package:equatable/equatable.dart';

abstract class ConfirmPickupEvent extends Equatable {
  const ConfirmPickupEvent();

  @override
  List<Object?> get props => [];
}

class TakePhotoEvent extends ConfirmPickupEvent {}

class TogglePackageCheckedEvent extends ConfirmPickupEvent {}

class SubmitConfirmPickupEvent extends ConfirmPickupEvent {}

class ConfirmPickupCameraTapped extends ConfirmPickupEvent {}
