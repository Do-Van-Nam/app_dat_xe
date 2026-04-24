part of 'interprovince_ride_bloc.dart';

sealed class InterprovinceRideState {}

final class InterprovinceRideInitial extends InterprovinceRideState {}

final class InterprovinceRideLoading extends InterprovinceRideState {}

final class InterprovinceRideSuccess extends InterprovinceRideState {
  final String rideId;
  InterprovinceRideSuccess(this.rideId);
}

final class InterprovinceRideError extends InterprovinceRideState {
  final String message;
  InterprovinceRideError(this.message);
}

class InterprovinceRideLoaded extends InterprovinceRideState {
  final String pickupPoint;
  final String pickupPlaceId;
  final GoongLocationCoords? pickupCoords;
  final String destination;
  final String destinationPlaceId;
  final GoongLocationCoords? destinationCoords;

  final DateTime selectedDate;
  final TimeOfDay pickupTime;

  final List<Vehicle> vehicles;
  final int? selectedVehicleType;

  final String currentLocation;
  final bool isLoadingLocation;
  final UniqueError? uniqueError;

  InterprovinceRideLoaded({
    this.pickupPoint = "",
    this.pickupPlaceId = "",
    this.pickupCoords,
    this.destination = "",
    this.destinationPlaceId = "",
    this.destinationCoords,
    required this.selectedDate,
    required this.pickupTime,
    required this.vehicles,
    this.selectedVehicleType,
    this.currentLocation = "Đang tìm kiếm vị trí...",
    this.isLoadingLocation = false,
    this.uniqueError,
  });

  InterprovinceRideLoaded copyWith({
    String? pickupPoint,
    String? pickupPlaceId,
    GoongLocationCoords? pickupCoords,
    String? destination,
    String? destinationPlaceId,
    GoongLocationCoords? destinationCoords,
    DateTime? selectedDate,
    TimeOfDay? pickupTime,
    List<Vehicle>? vehicles,
    int? selectedVehicleType,
    String? currentLocation,
    bool? isLoadingLocation,
    UniqueError? uniqueError,
  }) {
    return InterprovinceRideLoaded(
      pickupPoint: pickupPoint ?? this.pickupPoint,
      pickupPlaceId: pickupPlaceId ?? this.pickupPlaceId,
      pickupCoords: pickupCoords ?? this.pickupCoords,
      destination: destination ?? this.destination,
      destinationPlaceId: destinationPlaceId ?? this.destinationPlaceId,
      destinationCoords: destinationCoords ?? this.destinationCoords,
      selectedDate: selectedDate ?? this.selectedDate,
      pickupTime: pickupTime ?? this.pickupTime,
      vehicles: vehicles ?? this.vehicles,
      selectedVehicleType: selectedVehicleType ?? this.selectedVehicleType,
      currentLocation: currentLocation ?? this.currentLocation,
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
      uniqueError: uniqueError ?? this.uniqueError,
    );
  }
}
