import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../driver_models.dart';

part 'driver_event.dart';
part 'driver_state.dart';

class DriverBloc extends Bloc<DriverEvent, DriverState> {
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
  }

  Timer? _countdownTimer;
  Timer? _mockRideTimer;

  void _onToggleOnline(ToggleOnlineStatus event, Emitter<DriverState> emit) {
    if (state.screen == DriverScreen.offline) {
      // Go online
      emit(state.copyWith(screen: DriverScreen.online));
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
    } else {
      // Go offline
      _cancelTimers();
      emit(state.copyWith(
        screen: DriverScreen.offline,
        clearOffer: true,
      ));
    }
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

  void _onRideAccepted(RideAccepted event, Emitter<DriverState> emit) {
    _countdownTimer?.cancel();
    emit(state.copyWith(
      screen: DriverScreen.goingToPickup,
      clearOffer: true,
    ));
  }

  void _onRideRejected(RideRejected event, Emitter<DriverState> emit) {
    _countdownTimer?.cancel();
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
