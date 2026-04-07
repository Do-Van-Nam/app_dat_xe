import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'trip_detail_event.dart';
part 'trip_detail_state.dart';

class TripDetailBloc extends Bloc<TripDetailEvent, TripDetailState> {
  TripDetailBloc() : super(TripDetailInitial()) {
    on<LoadTripDetailEvent>(_onLoad);
  }

  Future<void> _onLoad(
      LoadTripDetailEvent event, Emitter<TripDetailState> emit) async {
    emit(TripDetailLoading());
    await Future.delayed(const Duration(milliseconds: 700));

    emit(TripDetailLoaded(
      isCompleted: true,
      driverName: "Nguyễn Văn An",
      vehicleInfo: "Honda City • 51G-123.45",
      rating: 4.9,
      totalTrips: 1240,
      pickupAddress: "Vinhomes Central Park, Bình Thạnh",
      pickupTime: "08:30",
      destinationAddress: "Tòa nhà Bitexco Financial Tower, Quận 1",
      destinationTime: "08:55",
      distance: 5.2,
      durationMinutes: 25,
      baseFare: 65000,
      serviceFee: 2000,
      discount: 15000,
      totalAmount: 52000,
    ));
  }
}
