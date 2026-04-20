import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:demo_app/main/data/model/ride/ride.dart';
import 'package:demo_app/main/data/model/unique_error.dart';
import 'package:demo_app/main/data/repository/driver_repository.dart';
import 'package:demo_app/main/data/service/socket_service/driver_socket_service.dart';
import 'package:demo_app/main/data/service/socket_service/socket_service.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:equatable/equatable.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../driver_models.dart';

part 'driver_event.dart';
part 'driver_state.dart';

class DriverBloc extends Bloc<DriverEvent, DriverState> {
  late StreamSubscription _sub;
  final DriverSocketService _driverSocketService = DriverSocketService();
  DriverBloc() : super(const DriverState()) {
    on<ToggleOnlineStatus>(_onToggleOnline);
    on<NewRideArrived>(_onNewRide);
    on<RideAccepted>(_onRideAccepted);
    on<RideRejected>(_onRideRejected);
    on<CountdownTicked>(_onCountdownTicked);
    on<ArrivedAtPickup>(_onArrivedPickup);
    on<TripStarted>(_onTripStarted);
    on<ArrivedAtDestination>(_onArrivedDest);
    on<TripCompleted>(_onTripCompleted);
    on<NavTabChanged>(_onNavTab);
    on<SosTapped>(_onSos);
    on<ChatTapped>(_onChat);
    on<CallTapped>(_onCall);
    on<DebugChangeScreen>((event, emit) {
      emit(state.copyWith(screen: event.screen
          // ,
          // isAutoFetchRoute: true,
          // destinationPoint: LatLng(
          //   21.0404426 + (Random().nextDouble() - 0.5) * 0.01,
          //   105.7732939 + (Random().nextDouble() - 0.5) * 0.01,
          // )
          ));
    });
    //khoi tao driver socket service o man home
    print("khoi tao driver socket service o driver bloc");
    _driverSocketService.init();

    _sub = _driverSocketService.onRideEvent.listen((data) {
      print("data tu driver  socket service trong driver bloc $data");
      final status = switch (data["event"]) {
        "ride.arrived" => DriverScreen.goingToPickup,
        "ride.picked_up" => DriverScreen.goingToPickup,
        "ride.started" => DriverScreen.goingToPickup,
        "ride.new_offer" => DriverScreen.newRide,
        "ride.completed" => DriverScreen.goingToPickup,
        "ride.rejected" || "ride.cancelled" => DriverScreen.goingToPickup,
        _ => null,
      };
      if (status != null) {
        print("driver bloc nhan duoc event ${data["event"]}");
        print("data ${data["data"]}");
// {user_id: 160245943409884827, event: ride.new_offer, ride_id: 160803027243049444, pickup_address: 5 ngo 58 tran vy, destination_address: 5 ngo 58 tran vy, distance_km: 5, total_price: 35000, vehicle_type: BIKE, occurred_at: 2026-04-20T09:21:09+00:00}
        print("rideId ${data["data"]["ride_id"]}");
        print("pickupAddress ${data["data"]["pickup_address"]}");
        print("destinationAddress ${data["data"]["destination_address"]}");
        print("distanceKm ${data["data"]["distance_km"]}");
        print("totalPrice ${data["data"]["total_price"]}");
        print("vehicleType ${data["data"]["vehicle_type"]}");
        print("occurredAt ${data["data"]["occurred_at"]}");
        // final Ride ride = Ride.fromJson(data["data"]);
        final dataMap = data["data"] as Map<String, dynamic>? ?? {};

        final Ride ride1 = Ride(
          id: (dataMap["ride_id"] ?? "").toString(), // An toàn
          pickupAddress: (dataMap["pickup_address"] ?? "").toString(),
          destinationAddress: (dataMap["destination_address"] ?? "").toString(),

          distance: (dataMap["distance_km"] as num?)?.toDouble() ?? 0.0,

          vehicleType: dataMap["vehicle_type"] == "BIKE" ? 1 : 2,

          totalPrice: (dataMap["total_price"] ?? "").toString(),

          isPaid: dataMap["is_paid"] == true,

          createdAt: dataMap["created_at"] != null
              ? DateTime.tryParse(dataMap["created_at"].toString()) ??
                  DateTime.now()
              : DateTime.now(),

          updatedAt: dataMap["updated_at"] != null
              ? DateTime.tryParse(dataMap["updated_at"].toString()) ??
                  DateTime.now()
              : DateTime.now(),

          deletedAt: dataMap["deleted_at"] != null
              ? DateTime.tryParse(dataMap["deleted_at"].toString())
              : null,

          voucherCode: dataMap["voucher_code"]?.toString(),
          discountAmount: (dataMap["discount_amount"] ?? "").toString(),
          cancelReason: dataMap["cancel_reason"]?.toString(),
          cancellationFee: (dataMap["cancellation_fee"] ?? "").toString(),
          timeFare: (dataMap["time_fare"] ?? "").toString(),
        );

        // emit(state.copyWith(currentOffer: ride1));
        add(NewRideArrived(ride1));
        // add(ChangeTrackingStatusEvent(status: status));
      }
      // data tu user socket service trong finding driver bloc {event: ride.accepted, data: {event: ride.accepted, ride_id: 160403560485574447, driver: {id: 160218433070182013, full_name: driver4, vehicle_name: hshsj, vehicle_number: shnanan, vehicle_type: 1, current_lat: 10.776889, current_lng: 106.700806}, occurred_at: 2026-04-18T04:28:30+00:00}}
    });
  }

  Timer? _countdownTimer;
  Timer? _mockRideTimer;
  final DriverRepository _driverRepository = DriverRepository();

  Future<void> _onToggleOnline(
      ToggleOnlineStatus event, Emitter<DriverState> emit) async {
    final bool isOnline = state.screen == DriverScreen.offline;
    final DriverScreen nextScreen =
        isOnline ? DriverScreen.online : DriverScreen.offline;
    // if (state.screen == DriverScreen.offline) {
    // Go online

    try {
      final (isSuccess, message) = await _driverRepository.updateStatus(
          isOnline: isOnline, lat: 0, lng: 0);

      if (isSuccess) {
        print("emit  success");
        emit(state.copyWith(screen: nextScreen));
      } else {
        print("emit  fail");
        emit(state.copyWith(error: UniqueError(message)));
      }
    } catch (e) {
      print("emit  fail: $e");
      emit(state.copyWith(error: UniqueError(e.toString())));
    }
    // Mock: simulate an incoming ride after 2 seconds
    // _mockRideTimer = Timer(const Duration(seconds: 2), () {
    //   if (!isClosed) {
    //     add(NewRideArrived(Ride(
    //       id: "160402426172027395",
    //       customerId: "158637144988007679",
    //       driverId: null,
    //       pickupAddress: "Số 1 Đào Duy Anh, Đống Đa, Hà Nội",
    //       pickupLat: "21.0072000",
    //       pickupLng: "105.8428000",
    //       destinationAddress: "Vincom Mega Mall Ocean Park, Gia Lâm, Hà Nội",
    //       destinationLat: "20.9944000",
    //       destinationLng: "105.9458000",
    //       distance: 5000,
    //       duration: 600,
    //       vehicleType: 1,
    //       status: 2,
    //       basePrice: "12000.00",
    //       distancePrice: "20000.00",
    //       totalPrice: "35000.00",
    //       voucherId: null,
    //       isPaid: false,
    //       createdAt: DateTime.parse("2026-04-18T03:37:58.000000Z"),
    //       updatedAt: DateTime.parse("2026-04-18T03:40:13.000000Z"),
    //       deletedAt: null,
    //       voucherCode: null,
    //       discountAmount: "0.00",
    //       cancelReason: null,
    //       cancellationFee: "0.00",
    //       timeFare: "3000.00",
    //       // trackingStatus: null,
    //       // driverAssignedAt: null,
    //       // driverArrivedAt: null,
    //       // trackingLastPingAt: null
    //     )));
    //   }
    // });
    // } else {
    //   // Go offline
    //   _cancelTimers();
    //   emit(state.copyWith(
    //     screen: DriverScreen.offline,
    //     clearOffer: true,
    //   ));
    // }
  }

  void _onNewRide(NewRideArrived event, Emitter<DriverState> emit) {
    emit(state.copyWith(
      screen: DriverScreen.newRide,
      currentOffer: event.offer,
      countdownSeconds: 15,
    ));
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      final remaining = state.countdownSeconds - 1;
      if (!isClosed) add(CountdownTicked(remaining));
    });
  }

  Future<void> _onCountdownTicked(
      CountdownTicked event, Emitter<DriverState> emit) async {
    if (event.remaining <= 0) {
      _countdownTimer?.cancel();
      // Auto-reject if no action taken
      final (isSuccess, message) =
          await _driverRepository.rejectRide(state.currentOffer?.id ?? "0");
      if (isSuccess) {
        emit(state.copyWith(screen: DriverScreen.online, clearOffer: true));
      } else {
        emit(state.copyWith(error: UniqueError(message)));
      }
    } else {
      emit(state.copyWith(countdownSeconds: event.remaining));
    }
  }

  Future<void> _onRideAccepted(
      RideAccepted event, Emitter<DriverState> emit) async {
    try {
      final position = await SharePreferenceUtil.getCurrentPosition();
      final (isSuccess, message, ride) = await _driverRepository.acceptRide(
          rideId: state.currentOffer?.id ?? "0",
          lat: position?.latitude ?? 0,
          lng: position?.longitude ?? 0);
      print("ride sau khi accept: ${ride.toJson()}");
      if (isSuccess) {
        print("emit  success");
        _countdownTimer?.cancel();
        emit(state.copyWith(
          screen: DriverScreen.goingToPickup,
          currentOffer: ride,
          clearOffer: true,
        ));
      } else {
        print("emit  fail");
        emit(state.copyWith(error: UniqueError(message)));
      }
    } catch (e) {
      print("emit  fail: $e");
      emit(state.copyWith(error: UniqueError(e.toString())));
    }
    // bat de test, sau nay xoa di
    // emit(state.copyWith(
    //   screen: DriverScreen.goingToPickup,
    //   clearOffer: true,
    // ));
  }

  Future<void> _onRideRejected(
      RideRejected event, Emitter<DriverState> emit) async {
    try {
      final (isSuccess, message) =
          await _driverRepository.rejectRide(state.currentOffer?.id ?? "0");

      if (isSuccess) {
        _countdownTimer?.cancel();
        print("emit  success");
        emit(state.copyWith(screen: DriverScreen.online, clearOffer: true));
      } else {
        print("emit  fail");
        emit(state.copyWith(error: UniqueError(message)));
      }
    } catch (e) {
      print("emit  fail: $e");
      emit(state.copyWith(error: UniqueError(e.toString())));
    }
    // bat de test sau nay xoa di
    // emit(state.copyWith(screen: DriverScreen.online, clearOffer: true));
  }

  Future<void> _onArrivedPickup(
      ArrivedAtPickup event, Emitter<DriverState> emit) async {
    try {
      print(
          "current offer o ham da toi diem don: ${state.currentOffer?.toJson()}");
      final position = await SharePreferenceUtil.getCurrentPosition();
      final (isSuccess, message) = await _driverRepository.arrivedAtPickup(
          state.currentOffer?.id ?? "0",
          position?.latitude ?? 0,
          position?.longitude ?? 0);

      if (isSuccess) {
        print("emit  success");
        emit(state.copyWith(screen: DriverScreen.arrivedPickup));
      } else {
        print("emit  fail");
        emit(state.copyWith(error: UniqueError(message)));
      }
    } catch (e) {
      print("emit  fail: $e");
      emit(state.copyWith(error: UniqueError(e.toString())));
    }
    // bat de test sau nay xoa di
    // emit(state.copyWith(screen: DriverScreen.arrivedPickup));
  }

  Future<void> _onTripStarted(
      TripStarted event, Emitter<DriverState> emit) async {
    try {
      final position = await SharePreferenceUtil.getCurrentPosition();
      final (isSuccess, message) = await _driverRepository.confirmPickup(
          state.currentOffer?.id ?? "0",
          position?.latitude ?? 0,
          position?.longitude ?? 0);
      final (isSuccess1, message1) = await _driverRepository.startRide(
          state.currentOffer?.id ?? "0",
          position?.latitude ?? 0,
          position?.longitude ?? 0);
      if (isSuccess && isSuccess1) {
        print("emit  success");
        emit(state.copyWith(screen: DriverScreen.startTrip));
      } else {
        print("emit  fail");
        emit(state.copyWith(error: UniqueError(message)));
      }
    } catch (e) {
      print("emit  fail: $e");
      emit(state.copyWith(error: UniqueError(e.toString())));
    }
    //debug
    // emit(state.copyWith(screen: DriverScreen.startTrip));
  }

  Future<void> _onArrivedDest(
      ArrivedAtDestination event, Emitter<DriverState> emit) async {
    try {
      final position = await SharePreferenceUtil.getCurrentPosition();
      final (isSuccess, message) = await _driverRepository.completeRide(
          state.currentOffer?.id ?? "0",
          position?.latitude ?? 0,
          position?.longitude ?? 0);

      if (isSuccess) {
        print("emit  success");
        emit(state.copyWith(screen: DriverScreen.arrivedDest));
      } else {
        print("emit  fail");
        emit(state.copyWith(error: UniqueError(message)));
      }
    } catch (e) {
      print("emit  fail: $e");
      emit(state.copyWith(error: UniqueError(e.toString())));
    }
    //debug
    // emit(state.copyWith(screen: DriverScreen.arrivedDest));
  }

  Future<void> _onTripCompleted(
      TripCompleted event, Emitter<DriverState> emit) async {
    try {
      final position = await SharePreferenceUtil.getCurrentPosition();
      final (isSuccess, message) = await _driverRepository.completeRide(
          state.currentOffer?.id ?? "0",
          position?.latitude ?? 0,
          position?.longitude ?? 0);

      if (isSuccess) {
        print("emit  success");
        emit(state.copyWith(screen: DriverScreen.arrivedDest));
      } else {
        print("emit  fail");
        emit(state.copyWith(error: UniqueError(message)));
      }
    } catch (e) {
      print("emit  fail: $e");
      emit(state.copyWith(error: UniqueError(e.toString())));
    }
    emit(state.copyWith(
      screen: DriverScreen.online,
      todayIncome: state.todayIncome +
          (int.parse(state.currentOffer?.totalPrice ?? "0")),
      totalTrips: state.totalTrips + 1,
    ));
    //debug
    // emit(state.copyWith(screen: DriverScreen.online));
  }

  void _onNavTab(NavTabChanged event, Emitter<DriverState> emit) {
    emit(state.copyWith(selectedTab: event.tab));
  }

  void _onSos(SosTapped event, Emitter<DriverState> emit) {}
  void _onChat(ChatTapped event, Emitter<DriverState> emit) {}
  void _onCall(CallTapped event, Emitter<DriverState> emit) {}

  void _cancelTimers() {
    _countdownTimer?.cancel();
    _mockRideTimer?.cancel();
  }

  @override
  Future<void> close() {
    _cancelTimers();
    return super.close();
  }
}
