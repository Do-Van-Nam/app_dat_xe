import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:demo_app/main/data/model/unique_error.dart';
import 'package:demo_app/main/data/repository/driver_repository.dart';
import 'package:demo_app/main/data/service/socket_service/socket_service.dart';
import 'package:equatable/equatable.dart';

import '../driver_models.dart';

part 'driver_event.dart';
part 'driver_state.dart';

class DriverBloc extends Bloc<DriverEvent, DriverState> {
  final SocketService _socketService = SocketService();
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

    print("bloc log bat dau khoi tao socket");
    // connectToRealtime();
    // Khởi tạo Socket khi Bloc được tạo
    _socketService.init();

    // Lắng nghe từ SocketService
    _socketService.onApplicationApproved.listen((data) {
      // add(WaitingApprovalStatusUpdated(WaitingApprovalPageStatus.approved));
      print("data: $data");
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
    _mockRideTimer = Timer(const Duration(seconds: 2), () {
      if (!isClosed) {
        add(const NewRideArrived(RideOffer(
          distanceKm: 1.2,
          estimatedEarning: 29000,
          pickupAddress: '123 Lê Lợi, Q1',
          dropoffAddress: '456 Nguyễn Huệ, Q1',
        )));
      }
    });
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
      countdownSeconds: event.offer.countdownSeconds,
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

  void _onCountdownTicked(CountdownTicked event, Emitter<DriverState> emit) {
    if (event.remaining <= 0) {
      _countdownTimer?.cancel();
      // Auto-reject if no action taken
      emit(state.copyWith(screen: DriverScreen.online, clearOffer: true));
    } else {
      emit(state.copyWith(countdownSeconds: event.remaining));
    }
  }

  Future<void> _onRideAccepted(
      RideAccepted event, Emitter<DriverState> emit) async {
    _countdownTimer?.cancel();
    try {
      final (isSuccess, message) =
          await _driverRepository.acceptRide(rideId: 123, lat: 1, lng: 1);

      if (isSuccess) {
        print("emit  success");
        emit(state.copyWith(
          screen: DriverScreen.goingToPickup,
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
    emit(state.copyWith(
      screen: DriverScreen.goingToPickup,
      clearOffer: true,
    ));
  }

  Future<void> _onRideRejected(
      RideRejected event, Emitter<DriverState> emit) async {
    _countdownTimer?.cancel();
    try {
      final (isSuccess, message) = await _driverRepository.rejectRide(123);

      if (isSuccess) {
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
    emit(state.copyWith(screen: DriverScreen.online, clearOffer: true));
  }

  void _onArrivedPickup(ArrivedAtPickup event, Emitter<DriverState> emit) {
    emit(state.copyWith(screen: DriverScreen.arrivedPickup));
  }

  void _onTripStarted(TripStarted event, Emitter<DriverState> emit) {
    emit(state.copyWith(screen: DriverScreen.startTrip));
  }

  void _onArrivedDest(ArrivedAtDestination event, Emitter<DriverState> emit) {
    emit(state.copyWith(screen: DriverScreen.arrivedDest));
  }

  void _onTripCompleted(TripCompleted event, Emitter<DriverState> emit) {
    emit(state.copyWith(
      screen: DriverScreen.online,
      todayIncome:
          state.todayIncome + (state.currentOffer?.estimatedEarning ?? 29000),
      totalTrips: state.totalTrips + 1,
    ));
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
