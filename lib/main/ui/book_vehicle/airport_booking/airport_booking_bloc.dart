import 'package:flutter_bloc/flutter_bloc.dart';
import 'airport_booking_event.dart';
import 'airport_booking_state.dart';

class AirportBookingBloc
    extends Bloc<AirportBookingEvent, AirportBookingState> {
  AirportBookingBloc()
      : super(AirportBookingState(isToAirport: true, selectedCarIndex: 1)) {
    on<LoadDataEvent>((event, emit) {});

    on<SelectTripTypeEvent>((event, emit) {
      emit(state.copyWith(isToAirport: event.isToAirport));
    });

    on<SelectCarEvent>((event, emit) {
      emit(state.copyWith(selectedCarIndex: event.index));
    });
  }
}
