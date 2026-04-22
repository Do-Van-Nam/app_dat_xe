import 'package:bloc/bloc.dart';
import 'package:demo_app/main/data/model/ride/ride_income_summary.dart';
import 'package:demo_app/main/data/model/unique_error.dart';
import 'package:demo_app/main/data/repository/driver_repository.dart';
import 'package:equatable/equatable.dart';

part 'rate_trip_event.dart';
part 'rate_trip_state.dart';

class RateTripBloc extends Bloc<RateTripEvent, RateTripState> {
  final String rideId;
  RateTripBloc({required this.rideId}) : super(const RateTripState()) {
    on<RateTripLoaded>(_onLoaded);
    on<RateTripConfirmTapped>(_onConfirmTapped);

    add(const RateTripLoaded());
  }

  Future<void> _onLoaded(
    RateTripLoaded event,
    Emitter<RateTripState> emit,
  ) async {
    emit(state.copyWith(status: RateTripStatus.loading));

    try {
      final (isSuccess, message, trip) =
          await DriverRepository().getIncomeSummary(rideId);

      if (isSuccess) {
        print("emit  success");
        emit(state.copyWith(trip: trip, status: RateTripStatus.initial));
      } else {
        print("emit  fail");
        emit(state.copyWith(
            errorMessage: UniqueError(message),
            status: RateTripStatus.initial));
      }
    } catch (e) {
      print("emit  fail: $e");
      emit(state.copyWith(
          errorMessage: UniqueError(e.toString()),
          status: RateTripStatus.initial));
    }
  }

  Future<void> _onConfirmTapped(
    RateTripConfirmTapped event,
    Emitter<RateTripState> emit,
  ) async {
    emit(state.copyWith(status: RateTripStatus.confirming));
    try {
      // TODO: call repository to mark driver as "ready for next trip"
      final (isSuccess, message) =
          await DriverRepository().confirmReady(rideId);

      if (isSuccess) {
        print("emit  success");
        emit(state.copyWith(status: RateTripStatus.confirmed));
      } else {
        print("emit  fail");
        emit(state.copyWith(
          errorMessage: UniqueError(message),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: RateTripStatus.error,
        errorMessage: UniqueError(e.toString()),
      ));
    }
  }
}
