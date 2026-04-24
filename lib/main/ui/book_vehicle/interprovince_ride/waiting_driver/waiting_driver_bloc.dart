import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:demo_app/main/data/repository/ride_repository.dart';
import 'package:demo_app/main/data/service/socket_service/driver_socket_service.dart';
import 'package:intl/intl.dart';

part 'waiting_driver_event.dart';
part 'waiting_driver_state.dart';

class WaitingDriverBloc extends Bloc<WaitingDriverEvent, WaitingDriverState> {
  StreamSubscription<Map<String, dynamic>>? _rideEventSubscription;
  Timer? _pollingTimer;

  WaitingDriverBloc() : super(const WaitingDriverState()) {
    on<WaitingDriverInit>(_onInit);
    on<WaitingDriverDriverFound>(_onDriverFound);
    on<WaitingDriverSearchFailed>(_onSearchFailed);
    on<WaitingDriverMoreOptionsTapped>(_onMoreOptionsTapped);
    on<WaitingDriverCancelTapped>(_onCancelTapped);
    on<WaitingDriverCancelConfirmed>(_onCancelConfirmed);
  }

  Future<void> _onInit(
    WaitingDriverInit event,
    Emitter<WaitingDriverState> emit,
  ) async {
    _stopSearching();
    emit(state.copyWith(rideId: event.rideId));

    // Get initial info
    final (ok, ride) = await RideRepository().getRideDetail(event.rideId);
    if (ok && ride != null) {
      emit(
        state.copyWith(
          pickupAddress: ride.pickupAddress,
          destinationAddress: ride.destinationAddress,
          scheduleValue:
              "${ride.travelTime} - ${DateFormat('dd/MM/yyyy').format(ride.travelDate ?? DateTime.now())}",
        ),
      );

      if (_hasDriverAssigned(ride)) {
        add(const WaitingDriverDriverFound());
        return;
      }
    }

    _startSearching();
  }

  Future<void> _startSearching() async {
    final rideId = state.rideId;
    if (rideId.isEmpty) {
      add(const WaitingDriverSearchFailed('Missing ride ID'));
      return;
    }

    try {
      await DriverSocketService().init(rideId: rideId);
      _rideEventSubscription ??=
          DriverSocketService().onRideEvent.listen((data) {
        final event = data['event'];
        final payload = data['data'];
        final eventRideId =
            (payload is Map<String, dynamic> ? payload['ride_id'] : null)
                ?.toString();

        if (eventRideId != null && eventRideId != rideId) {
          return;
        }

        if (event == 'ride.accepted') {
          add(const WaitingDriverDriverFound());
        } else if (event == 'ride.rejected' || event == 'ride.cancelled') {
          add(const WaitingDriverSearchFailed('Driver search stopped'));
        }
      });
    } catch (_) {
      // Fall back to repository polling when socket init fails.
    }

    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (isClosed || state.status != WaitingDriverStatus.searching) {
        _stopSearching();
        return;
      }

      final (ok, ride) = await RideRepository().getRideDetail(rideId);
      if (ok && ride != null && _hasDriverAssigned(ride)) {
        add(const WaitingDriverDriverFound());
      }
    });
  }

  bool _hasDriverAssigned(dynamic ride) {
    return ride.driverId != null && ride.driverId.toString().isNotEmpty;
  }

  void _stopSearching() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  void _onDriverFound(
    WaitingDriverDriverFound event,
    Emitter<WaitingDriverState> emit,
  ) {
    _stopSearching();
    print("Driver found");
    emit(state.copyWith(status: WaitingDriverStatus.found));
    // TODO: navigate to driver-on-the-way screen
  }

  void _onSearchFailed(
    WaitingDriverSearchFailed event,
    Emitter<WaitingDriverState> emit,
  ) {
    _stopSearching();
    emit(state.copyWith(
      status: WaitingDriverStatus.error,
      errorMessage: event.message,
    ));
  }

  void _onMoreOptionsTapped(
    WaitingDriverMoreOptionsTapped event,
    Emitter<WaitingDriverState> emit,
  ) {
    // TODO: show bottom sheet with options
  }

  void _onCancelTapped(
    WaitingDriverCancelTapped event,
    Emitter<WaitingDriverState> emit,
  ) {
    // Show confirmation dialog from the UI layer;
    // actual cancellation fires WaitingDriverCancelConfirmed.
  }

  Future<void> _onCancelConfirmed(
    WaitingDriverCancelConfirmed event,
    Emitter<WaitingDriverState> emit,
  ) async {
    _stopSearching();
    emit(state.copyWith(isCancelLoading: true));
    try {
      final (ok, _) = await RideRepository()
          .cancelRide(state.rideId, "Khách hàng thay đổi kế hoạch");

      if (ok) {
        emit(state.copyWith(
          isCancelLoading: false,
          status: WaitingDriverStatus.cancelled,
        ));
      } else {
        emit(state.copyWith(
          isCancelLoading: false,
          status: WaitingDriverStatus.error,
          errorMessage: "Hủy chuyến thất bại",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isCancelLoading: false,
        status: WaitingDriverStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  @override
  Future<void> close() async {
    _stopSearching();
    await _rideEventSubscription?.cancel();
    return super.close();
  }
}
