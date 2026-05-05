import 'dart:async';

import 'package:demo_app/main/data/model/ride/ride.dart';
import 'package:demo_app/main/data/model/ride/tracking.dart';
import 'package:demo_app/main/data/model/unique_error.dart';
import 'package:demo_app/main/data/repository/ride_repository.dart';
import 'package:demo_app/main/data/service/socket_service/driver_socket_service.dart';
import 'package:demo_app/main/utils/utility_fuctions.dart';
// import 'package:demo_app/main/data/service/socket_service/user_socket_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:meta/meta.dart';

part 'tracking_event.dart';
part 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  late StreamSubscription _sub;
  final Ride ride;
  TrackingBloc({required this.ride}) : super(TrackingInitial()) {
    on<LoadTrackingDataEvent>(_onLoadData);
    on<CancelRideEvent>(_onCancelRide);
    on<CancelRideRequestEvent>(_onCancelRideRequest);
    on<ChangeTrackingStatusEvent>(_onChangeStatus);
    on<TrackingDriverUpdatedEvent>(_onDriverUpdated);
    on<ChatTapped>(_onChatTapped);
    on<CallTapped>(_onCallTapped);
    _sub = DriverSocketService().onRideEvent.listen((data) {
      print("data tu user socket service trong tracking bloc $data");
      if (data["event"] == "ride:tracking.updated") {
        final latLng = LatLng(data["data"]["location"]["lat"].toDouble(),
            data["data"]["location"]["lng"].toDouble());
        print("latLng: $latLng");

        add(TrackingDriverUpdatedEvent(location: latLng));
      }
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
  Future<void> _onDriverUpdated(
      TrackingDriverUpdatedEvent event, Emitter<TrackingState> emit) async {
    emit((state as TrackingLoaded).copyWith(driverLocation: event.location));
  }

  Future<void> _onLoadData(
      LoadTrackingDataEvent event, Emitter<TrackingState> emit) async {
    emit(TrackingLoading());
    try {
      print("ride trong tracking bloc ${ride.toJson()}");
      final (isSuccess, Tracking? tracking) =
          await RideRepository().getRideTracking(ride.id.toString());
      if (isSuccess && tracking != null) {
        emit(TrackingLoaded(
            driverName: tracking.driver?.name ?? "--",
            driverPhone: tracking.driver?.phone ?? "--",
            vehiclePlate: tracking.driver?.vehicleNumber ?? "--",
            vehicleName: tracking.driver?.vehicleName ?? "--",
            rating: tracking.driver?.rating ?? 0.0,
            arrivalTime: "KHOẢNG 2 PHÚT",
            distance: double.parse((ride.distance ?? "0").toString()) / 1000,
            discountedPrice: (ride.totalPrice ?? 0) as double,
            originalPrice: (ride.basePrice ?? 0) as double,
            pickupAddress: ride.pickupAddress ?? "--",
            destinationAddress: ride.destinationAddress ?? "--",
            status: TrackingStatus.driverArriving,
            ride: ride));
      }
    } catch (e) {
      emit(TrackingError("Không thể tải thông tin theo dõi : $e"));
    }
  }

  Future<void> _onCancelRide(
      CancelRideEvent event, Emitter<TrackingState> emit) async {
    // emit(TrackingLoading());

    try {
      final isSuccess =
          await RideRepository().cancelRideRequest(ride.id, "Hủy chuyến");

      if (isSuccess) {
        print("emit userCancellRequested");
        emit((state as TrackingLoaded)
            .copyWith(status: TrackingStatus.userCancelSuccess));
      } else {
        print("emit userCancellFailed");
        emit((state as TrackingLoaded)
            .copyWith(status: TrackingStatus.userCancelFailed));
      }
    } catch (e) {
      print("emit userCancellFailed: $e");
      emit((state as TrackingLoaded)
          .copyWith(status: TrackingStatus.userCancelFailed));
    }
  }

  Future<void> _onCancelRideRequest(
      CancelRideRequestEvent event, Emitter<TrackingState> emit) async {
    // emit(TrackingLoading());

    try {
      final isSuccess =
          await RideRepository().cancelRideRequest(ride.id, "Hủy chuyến");

      if (isSuccess) {
        print("emit userCancellRequested");
        emit((state as TrackingLoaded)
            .copyWith(status: TrackingStatus.userCancelSuccess));
      } else {
        print("emit userCancellFailed");
        emit((state as TrackingLoaded)
            .copyWith(status: TrackingStatus.userCancelFailed));
      }
    } catch (e) {
      print("emit userCancellFailed: $e");
      emit((state as TrackingLoaded)
          .copyWith(status: TrackingStatus.userCancelFailed));
    }
  }

  void _onChangeStatus(
      ChangeTrackingStatusEvent event, Emitter<TrackingState> emit) {
    emit((state as TrackingLoaded).copyWith(status: event.status));
  }

  void _onCallTapped(CallTapped event, Emitter<TrackingState> emit) {
    makePhoneCall((state as TrackingLoaded).driverPhone);
  }

  void _onChatTapped(ChatTapped event, Emitter<TrackingState> emit) {
    emit((state as TrackingLoaded).copyWith(error: UniqueError("goToChat")));
  }

  @override
  Future<void> close() {
    _sub.cancel(); // ⚠️ bắt buộc
    return super.close();
  }
}
