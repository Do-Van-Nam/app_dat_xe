part of 'scheduled_ride_bloc.dart';

enum TripType { urban, intercity, airport }

enum TripStatus { available, accepted, cancelled }

enum ScheduledRideLoadStatus { initial, loading, loaded, error }

class TripModel extends Equatable {
  const TripModel({
    required this.id,
    required this.pickupAddress,
    required this.destinationAddress,
    required this.departureDate,
    required this.departureTime,
    required this.type,
    required this.price,
    this.status = TripStatus.available,
    this.distance,
    this.estimatedMinutes,
  });

  final String id;
  final String pickupAddress;
  final String destinationAddress;
  final DateTime departureDate;
  final String departureTime;
  final TripType type;
  final int price;
  final TripStatus status;
  final String? distance;
  final int? estimatedMinutes;

  TripModel copyWith({TripStatus? status}) {
    return TripModel(
      id: id,
      pickupAddress: pickupAddress,
      destinationAddress: destinationAddress,
      departureDate: departureDate,
      departureTime: departureTime,
      type: type,
      price: price,
      status: status ?? this.status,
      distance: distance,
      estimatedMinutes: estimatedMinutes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        pickupAddress,
        destinationAddress,
        departureDate,
        departureTime,
        type,
        price,
        status,
        distance,
        estimatedMinutes,
      ];
}

class TripFilter extends Equatable {
  const TripFilter({
    this.date,
    this.time,
    this.tripType,
    this.priceMin,
    this.priceMax,
  });

  final DateTime? date;
  final String? time;
  final TripType? tripType;
  final int? priceMin;
  final int? priceMax;

  bool get hasActiveFilter =>
      date != null ||
      time != null ||
      tripType != null ||
      priceMin != null ||
      priceMax != null;

  TripFilter copyWith({
    DateTime? date,
    String? time,
    TripType? tripType,
    int? priceMin,
    int? priceMax,
    bool clearDate = false,
    bool clearTime = false,
    bool clearType = false,
    bool clearMin = false,
    bool clearMax = false,
  }) {
    return TripFilter(
      date: clearDate ? null : (date ?? this.date),
      time: clearTime ? null : (time ?? this.time),
      tripType: clearType ? null : (tripType ?? this.tripType),
      priceMin: clearMin ? null : (priceMin ?? this.priceMin),
      priceMax: clearMax ? null : (priceMax ?? this.priceMax),
    );
  }

  @override
  List<Object?> get props => [date, time, tripType, priceMin, priceMax];
}

class ScheduledRideState extends Equatable {
  const ScheduledRideState({
    this.loadStatus = ScheduledRideLoadStatus.initial,
    this.scheduledTrips = const [],
    this.managedTrips = const [],
    this.filter = const TripFilter(),
    this.selectedTabIndex = 0,
    this.processingTripId,
    this.errorMessage,
    this.successMessage,
  });

  final ScheduledRideLoadStatus loadStatus;
  final List<TripModel> scheduledTrips;
  final List<TripModel> managedTrips;
  final TripFilter filter;
  final int selectedTabIndex;
  final String? processingTripId;
  final String? errorMessage;
  final String? successMessage;

  List<TripModel> get availableTrips => scheduledTrips;

  List<TripModel> get acceptedTrips => managedTrips;

  ScheduledRideState copyWith({
    ScheduledRideLoadStatus? loadStatus,
    List<TripModel>? scheduledTrips,
    List<TripModel>? managedTrips,
    TripFilter? filter,
    int? selectedTabIndex,
    String? processingTripId,
    String? errorMessage,
    String? successMessage,
    bool clearProcessing = false,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return ScheduledRideState(
      loadStatus: loadStatus ?? this.loadStatus,
      scheduledTrips: scheduledTrips ?? this.scheduledTrips,
      managedTrips: managedTrips ?? this.managedTrips,
      filter: filter ?? this.filter,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      processingTripId:
          clearProcessing ? null : (processingTripId ?? this.processingTripId),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
        loadStatus,
        scheduledTrips,
        managedTrips,
        filter,
        selectedTabIndex,
        processingTripId,
        errorMessage,
        successMessage,
      ];
}
