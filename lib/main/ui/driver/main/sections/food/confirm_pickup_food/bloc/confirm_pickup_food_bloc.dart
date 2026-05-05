import 'package:bloc/bloc.dart';
import 'confirm_pickup_food_event.dart';
import 'confirm_pickup_food_state.dart';

class ConfirmPickupFoodBloc extends Bloc<ConfirmPickupFoodEvent, ConfirmPickupFoodState> {
  ConfirmPickupFoodBloc() : super(const ConfirmPickupFoodState()) {
    on<TakeFoodPhotoEvent>(_onTakeFoodPhoto);
    on<SubmitConfirmPickupFoodEvent>(_onSubmitConfirmPickupFood);
  }

  void _onTakeFoodPhoto(TakeFoodPhotoEvent event, Emitter<ConfirmPickupFoodState> emit) {
    emit(state.copyWith(isPhotoTaken: !state.isPhotoTaken)); 
  }

  Future<void> _onSubmitConfirmPickupFood(SubmitConfirmPickupFoodEvent event, Emitter<ConfirmPickupFoodState> emit) async {
    if (!state.isPhotoTaken) return;
    emit(state.copyWith(status: ConfirmPickupFoodStatus.loading));
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    emit(state.copyWith(status: ConfirmPickupFoodStatus.success));
  }
}
