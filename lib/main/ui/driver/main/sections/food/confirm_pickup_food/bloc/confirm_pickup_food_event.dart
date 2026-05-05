import 'package:equatable/equatable.dart';

abstract class ConfirmPickupFoodEvent extends Equatable {
  const ConfirmPickupFoodEvent();

  @override
  List<Object?> get props => [];
}

class TakeFoodPhotoEvent extends ConfirmPickupFoodEvent {}

class SubmitConfirmPickupFoodEvent extends ConfirmPickupFoodEvent {}
