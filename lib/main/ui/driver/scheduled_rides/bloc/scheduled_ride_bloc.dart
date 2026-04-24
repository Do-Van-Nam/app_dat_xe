import 'package:bloc/bloc.dart';
import 'package:demo_app/main/data/model/ride/ride.dart';
import 'package:demo_app/main/data/repository/driver_repository.dart';
import 'package:equatable/equatable.dart';

part 'scheduled_ride_event.dart';
part 'scheduled_ride_state.dart';

class ScheduledRideBloc extends Bloc<ScheduledRideEvent, ScheduledRideState> {
  ScheduledRideBloc({DriverRepository? repository})
      : _repo = repository ?? DriverRepository(),
        super(const ScheduledRideState()) {
    on<ScheduledRideLoadRequested>(_onLoad);
    on<ScheduledRideRefreshRequested>(_onRefresh);
    on<ScheduledRideTabChanged>(_onTabChanged);
    on<ScheduledRideFilterChanged>(_onFilterChanged);
    on<ScheduledRideFilterReset>(_onFilterReset);
    on<ScheduledRideAcceptTrip>(_onAcceptTrip);
    on<ScheduledRideCancelTrip>(_onCancelTrip);

    add(const ScheduledRideLoadRequested());
  }

  final DriverRepository _repo;

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  int? _toRideType(TripType? type) {
    switch (type) {
      case TripType.urban:
        return 1;
      case TripType.intercity:
        return 2;
      case TripType.airport:
        return 3;
      case null:
        return null;
    }
  }

  TripType _mapTripType(int? rideType) {
    switch (rideType) {
      case 2:
        return TripType.intercity;
      case 3:
        return TripType.airport;
      case 1:
      default:
        return TripType.urban;
    }
  }

  TripModel _mapRideToTrip(Ride ride, {required TripStatus status}) {
    final price =
        num.tryParse((ride.totalPrice ?? '0').toString())?.toInt() ?? 0;
    final distance = ride.distance == null
        ? null
        : '${(ride.distance!.toDouble() / 1000).toStringAsFixed(1)} km';

    return TripModel(
      id: (ride.rideId ?? 0).toString(),
      pickupAddress: ride.pickupAddress ?? '--',
      destinationAddress: ride.destinationAddress ?? '--',
      departureDate: ride.travelDate ?? ride.createdAt ?? DateTime.now(),
      departureTime: ride.travelTime ?? '',
      type: _mapTripType(ride.rideType?.toInt()),
      price: price,
      status: status,
      distance: distance,
    );
  }

  Future<void> _loadTrips(
    Emitter<ScheduledRideState> emit, {
    bool showLoading = true,
  }) async {
    if (showLoading) {
      emit(state.copyWith(
        loadStatus: ScheduledRideLoadStatus.loading,
        clearError: true,
        clearSuccess: true,
      ));
    }

    try {
      final filter = state.filter;
      final scheduledFuture = _repo.getScheduledRides(
        travelDate: filter.date != null ? _formatDate(filter.date!) : null,
        travelTime: filter.time,
        rideType: _toRideType(filter.tripType),
        minPrice: filter.priceMin,
        maxPrice: filter.priceMax,
      );
      final managedFuture = _repo.getManagedRides();

      final scheduledResult = await scheduledFuture;
      final managedResult = await managedFuture;

      emit(state.copyWith(
        loadStatus: ScheduledRideLoadStatus.loaded,
        scheduledTrips: scheduledResult.$2
            .map((ride) => _mapRideToTrip(ride, status: TripStatus.available))
            .toList(),
        managedTrips: managedResult.$2
            .map((ride) => _mapRideToTrip(ride, status: TripStatus.accepted))
            .toList(),
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        loadStatus: ScheduledRideLoadStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoad(
    ScheduledRideLoadRequested event,
    Emitter<ScheduledRideState> emit,
  ) async {
    await _loadTrips(emit);
  }

  Future<void> _onRefresh(
    ScheduledRideRefreshRequested event,
    Emitter<ScheduledRideState> emit,
  ) async {
    await _loadTrips(emit, showLoading: false);
  }

  void _onTabChanged(
    ScheduledRideTabChanged event,
    Emitter<ScheduledRideState> emit,
  ) {
    emit(state.copyWith(selectedTabIndex: event.index));
  }

  void _onFilterChanged(
    ScheduledRideFilterChanged event,
    Emitter<ScheduledRideState> emit,
  ) {
    emit(state.copyWith(
      filter: event.filter,
      clearError: true,
      clearSuccess: true,
    ));
    add(const ScheduledRideLoadRequested());
  }

  void _onFilterReset(
    ScheduledRideFilterReset event,
    Emitter<ScheduledRideState> emit,
  ) {
    emit(state.copyWith(
      filter: const TripFilter(),
      clearError: true,
      clearSuccess: true,
    ));
    add(const ScheduledRideLoadRequested());
  }

  Future<void> _onAcceptTrip(
    ScheduledRideAcceptTrip event,
    Emitter<ScheduledRideState> emit,
  ) async {
    emit(state.copyWith(
      processingTripId: event.tripId,
      clearError: true,
      clearSuccess: true,
    ));

    try {
      final (ok, acceptedRide) = await _repo.acceptScheduledRide(event.tripId);
      if (!ok) {
        emit(state.copyWith(
          errorMessage: 'Nhận chuyến thất bại',
          clearProcessing: true,
        ));
        return;
      }

      final ride =
          acceptedRide ?? (await _repo.getScheduledRideDetail(event.tripId)).$2;
      final scheduledTrips = state.scheduledTrips
          .where((trip) => trip.id != event.tripId)
          .toList();
      final managedTrips = [...state.managedTrips];

      if (ride != null) {
        managedTrips.removeWhere((trip) => trip.id == event.tripId);
        managedTrips.insert(
          0,
          _mapRideToTrip(ride, status: TripStatus.accepted),
        );
      }

      emit(state.copyWith(
        scheduledTrips: scheduledTrips,
        managedTrips: managedTrips,
        successMessage: 'Nhận chuyến thành công',
        clearProcessing: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString(),
        clearProcessing: true,
      ));
    }
  }

  Future<void> _onCancelTrip(
    ScheduledRideCancelTrip event,
    Emitter<ScheduledRideState> emit,
  ) async {
    emit(state.copyWith(
      processingTripId: event.tripId,
      clearError: true,
      clearSuccess: true,
    ));

    try {
      final (ok, cancelledRide) = await _repo.cancelScheduledRide(event.tripId);
      if (!ok) {
        emit(state.copyWith(
          errorMessage: 'Hủy chuyến thất bại',
          clearProcessing: true,
        ));
        return;
      }

      final ride = cancelledRide ??
          (await _repo.getScheduledRideDetail(event.tripId)).$2;
      final managedTrips =
          state.managedTrips.where((trip) => trip.id != event.tripId).toList();
      final scheduledTrips = [...state.scheduledTrips];

      if (ride != null) {
        scheduledTrips.removeWhere((trip) => trip.id == event.tripId);
        scheduledTrips.insert(
          0,
          _mapRideToTrip(ride, status: TripStatus.available),
        );
      }

      emit(state.copyWith(
        scheduledTrips: scheduledTrips,
        managedTrips: managedTrips,
        successMessage: 'Hủy chuyến thành công',
        clearProcessing: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString(),
        clearProcessing: true,
      ));
    }
  }
}
