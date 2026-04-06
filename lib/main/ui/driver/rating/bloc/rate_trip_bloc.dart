import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'rate_trip_event.dart';
part 'rate_trip_state.dart';

class RateTripBloc extends Bloc<RateTripEvent, RateTripState> {
  RateTripBloc() : super(const RateTripState()) {
    on<RateTripLoaded>(_onLoaded);
    on<RateTripConfirmTapped>(_onConfirmTapped);

    add(const RateTripLoaded());
  }

  Future<void> _onLoaded(
    RateTripLoaded event,
    Emitter<RateTripState> emit,
  ) async {
    // TODO: fetch real trip summary & review from repository
    // Data is pre-seeded via initial state; replace with API call if needed.
  }

  Future<void> _onConfirmTapped(
    RateTripConfirmTapped event,
    Emitter<RateTripState> emit,
  ) async {
    emit(state.copyWith(status: RateTripStatus.confirming));
    try {
      // TODO: call repository to mark driver as "ready for next trip"
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(status: RateTripStatus.confirmed));
    } catch (e) {
      emit(state.copyWith(
        status: RateTripStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
