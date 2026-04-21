import 'dart:async';

import 'package:demo_app/main/data/model/ride/ride.dart';
import 'package:demo_app/main/data/service/socket_service/user_socket_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'tracking_event.dart';
part 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  late StreamSubscription _sub;
  final Ride ride;
  TrackingBloc({required this.ride}) : super(TrackingInitial()) {
    on<LoadTrackingDataEvent>(_onLoadData);
    on<CancelRideEvent>(_onCancelRide);
    on<ChangeTrackingStatusEvent>(_onChangeStatus);
    _sub = UserSocketService().onRideEvent.listen((data) {
      print("data tu user socket service trong tracking bloc $data");
      final status = switch (data["event"]) {
        "ride.arrived" => TrackingStatus.driverArrived,
        "ride.picked_up" => TrackingStatus.driverPickedUp,
        "ride.started" => TrackingStatus.driverStarted,
        "ride.completed" => TrackingStatus.driverCompleted,
        "ride.rejected" || "ride.cancelled" => TrackingStatus.driverRejected,
        _ => null,
      };
      if (status != null) {
        print("tracking bloc nhan duoc event ${data["event"]}");
        add(ChangeTrackingStatusEvent(status: status));
      }
      // data tu user socket service trong finding driver bloc {event: ride.accepted, data: {event: ride.accepted, ride_id: 160403560485574447, driver: {id: 160218433070182013, full_name: driver4, vehicle_name: hshsj, vehicle_number: shnanan, vehicle_type: 1, current_lat: 10.776889, current_lng: 106.700806}, occurred_at: 2026-04-18T04:28:30+00:00}}
    });
  }

  Future<void> _onLoadData(
      LoadTrackingDataEvent event, Emitter<TrackingState> emit) async {
    emit(TrackingLoading());
    try {
      print("ride trong tracking bloc ${ride.toJson()}");
      emit(TrackingLoaded(
        driverName: "Nguyễn Văn A",
        vehiclePlate: "59-A1123.45",
        vehicleName: "Yamaha Exciter",
        rating: 4.9,
        arrivalTime: "KHOẢNG 2 PHÚT",
        distance: double.parse((ride.distance ?? "0").toString()) / 1000,
        discountedPrice: double.parse(ride.totalPrice ?? "0"),
        originalPrice: double.parse(ride.totalPrice ?? "0"),
        pickupAddress: ride.pickupAddress ?? "--",
        destinationAddress: ride.destinationAddress ?? "--",
        status: TrackingStatus.driverArriving,
      ));
    } catch (e) {
      emit(TrackingError("Không thể tải thông tin theo dõi : $e"));
    }
  }

  void _onCancelRide(CancelRideEvent event, Emitter<TrackingState> emit) {
    // Thực tế sẽ gọi API hủy chuyến
    emit(TrackingError("Chuyến đã được hủy"));
  }

  void _onChangeStatus(
      ChangeTrackingStatusEvent event, Emitter<TrackingState> emit) {
    emit((state as TrackingLoaded).copyWith(status: event.status));
  }

  @override
  Future<void> close() {
    _sub.cancel(); // ⚠️ bắt buộc
    return super.close();
  }
}
