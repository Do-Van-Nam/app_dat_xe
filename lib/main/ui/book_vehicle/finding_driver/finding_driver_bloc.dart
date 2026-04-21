import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:demo_app/main/data/model/ride/ride.dart';
import 'package:demo_app/main/data/repository/ride_repository.dart';
import 'package:demo_app/main/data/service/socket_service/user_socket_service.dart';
import 'package:demo_app/main/utils/service/local_notification_service.dart';
import 'package:equatable/equatable.dart';

part 'finding_driver_event.dart';
part 'finding_driver_state.dart';

class FindingDriverBloc extends Bloc<FindingDriverEvent, FindingDriverState> {
  final Ride? ride;
  late StreamSubscription _sub;

  FindingDriverBloc({this.ride})
      : super(FindingDriverState(
          pickupAddress: ride?.pickupAddress ?? '',
          destinationAddress: ride?.destinationAddress ?? '',
          estimatedPrice:
              double.tryParse(ride?.totalPrice ?? '0')?.toInt() ?? 0,
          distance: (ride?.distance?.toDouble() ?? 0.0) / 1000,
        )) {
    on<FindingDriverStartSearch>(_onStartSearch);
    on<FindingDriverCancelSearch>(_onCancelSearch);
    on<FindingDriverFound>(_onDriverFound);
    on<FindingDriverTimeout>(_onTimeout);
    _sub = UserSocketService().onRideEvent.listen((data) {
      print("data tu user socket service trong finding driver bloc $data");
      if (data["event"] == "ride.accepted") {
        add(const FindingDriverFound());
      }
      // data tu user socket service trong finding driver bloc {event: ride.accepted, data: {event: ride.accepted, ride_id: 160403560485574447, driver: {id: 160218433070182013, full_name: driver4, vehicle_name: hshsj, vehicle_number: shnanan, vehicle_type: 1, current_lat: 10.776889, current_lng: 106.700806}, occurred_at: 2026-04-18T04:28:30+00:00}}
    });
  }

  Future<void> _onStartSearch(
    FindingDriverStartSearch event,
    Emitter<FindingDriverState> emit,
  ) async {
    emit(state.copyWith(status: FindingDriverStatus.searching));

    // // Simulate searching for a driver
    // await Future.delayed(const Duration(seconds: 8));

    // // Only emit if still searching (not cancelled)
    // if (state.status == FindingDriverStatus.searching) {
    //   add(const FindingDriverFound());
    // }
  }

  Future<void> _onCancelSearch(
    FindingDriverCancelSearch event,
    Emitter<FindingDriverState> emit,
  ) async {
    final (success, ride) = await RideRepository().cancelRide(
      this.ride?.id ?? "",
      "ly do huy",
    );
    if (success) {
      emit(state.copyWith(status: FindingDriverStatus.cancelled));
    } else {
      emit(state.copyWith(status: FindingDriverStatus.error));
    }
  }

  void _onDriverFound(
    FindingDriverFound event,
    Emitter<FindingDriverState> emit,
  ) async {
    emit(state.copyWith(status: FindingDriverStatus.found));
  }

  void _onTimeout(
    FindingDriverTimeout event,
    Emitter<FindingDriverState> emit,
  ) {
    emit(state.copyWith(status: FindingDriverStatus.timeout));
  }

  @override
  Future<void> close() {
    _sub.cancel(); // ⚠️ bắt buộc
    return super.close();
  }
}
