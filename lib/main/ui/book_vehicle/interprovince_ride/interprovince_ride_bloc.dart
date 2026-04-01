import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'interprovince_ride_event.dart';
part 'interprovince_ride_state.dart';

class InterprovinceRideBloc
    extends Bloc<InterprovinceRideEvent, InterprovinceRideState> {
  InterprovinceRideBloc()
      : super(InterprovinceRideState(
          selectedDate: DateTime.now(),
          pickupTime: const TimeOfDay(hour: 9, minute: 0),
        )) {
    on<LoadInitialData>(_onLoadInitialData);
    on<SelectVehicleType>(_onSelectVehicleType);
    on<ChangeDate>(_onChangeDate);
    on<ChangePickupTime>(_onChangePickupTime);
    on<UpdateDestination>(_onUpdateDestination);
  }

  void _onLoadInitialData(
      LoadInitialData event, Emitter<InterprovinceRideState> emit) {
    // Có thể load từ API/local storage sau này
    emit(state);
  }

  void _onSelectVehicleType(
      SelectVehicleType event, Emitter<InterprovinceRideState> emit) {
    double newPrice = event.typeIndex == 0
        ? 250000
        : event.typeIndex == 1
            ? 850000
            : 1200000;
    emit(state.copyWith(
        selectedVehicleType: event.typeIndex, estimatedPrice: newPrice));
  }

  void _onChangeDate(ChangeDate event, Emitter<InterprovinceRideState> emit) {
    emit(state.copyWith(selectedDate: event.newDate));
  }

  void _onChangePickupTime(
      ChangePickupTime event, Emitter<InterprovinceRideState> emit) {
    emit(state.copyWith(pickupTime: event.newTime));
  }

  void _onUpdateDestination(
      UpdateDestination event, Emitter<InterprovinceRideState> emit) {
    emit(state.copyWith(destination: event.destination));
  }
}
