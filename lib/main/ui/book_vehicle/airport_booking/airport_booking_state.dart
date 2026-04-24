part of 'airport_booking_bloc.dart';

@immutable
sealed class AirportBookingState {}

final class AirportBookingInitial extends AirportBookingState {}

final class AirportBookingLoading extends AirportBookingState {}

final class AirportBookingSuccess extends AirportBookingState {
  final String rideId;
  AirportBookingSuccess(this.rideId);
}

final class AirportBookingLoaded extends AirportBookingState {
  final int selectedTripType; // 0: Đi đến, 1: Đón từ
  final List<Airport> nearbyAirports;
  final Airport? selectedAirport;
  final List<Vehicle> vehicles;
  final int? selectedVehicleType;
  final String pickupPlaceId;
  final String currentLocation;
  final bool isLoadingLocation;
  final DateTime selectedDate;
  final TimeOfDay pickupTime;
  final GoongLocationCoords? pickupCoords;

  AirportBookingLoaded({
    this.selectedTripType = 0,
    required this.nearbyAirports,
    this.selectedAirport,
    required this.vehicles,
    this.selectedVehicleType,
    this.pickupPlaceId = "",
    this.currentLocation = "Đang tìm kiếm vị trí...",
    this.isLoadingLocation = false,
    required this.selectedDate,
    required this.pickupTime,
    this.pickupCoords,
  });

  AirportBookingLoaded copyWith({
    int? selectedTripType,
    List<Airport>? nearbyAirports,
    Airport? selectedAirport,
    List<Vehicle>? vehicles,
    int? selectedVehicleType,
    String? pickupPlaceId,
    String? currentLocation,
    bool? isLoadingLocation,
    DateTime? selectedDate,
    TimeOfDay? pickupTime,
    GoongLocationCoords? pickupCoords,
  }) {
    return AirportBookingLoaded(
      selectedTripType: selectedTripType ?? this.selectedTripType,
      nearbyAirports: nearbyAirports ?? this.nearbyAirports,
      selectedAirport: selectedAirport ?? this.selectedAirport,
      vehicles: vehicles ?? this.vehicles,
      selectedVehicleType: selectedVehicleType ?? this.selectedVehicleType,
      pickupPlaceId: pickupPlaceId ?? this.pickupPlaceId,
      currentLocation: currentLocation ?? this.currentLocation,
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
      selectedDate: selectedDate ?? this.selectedDate,
      pickupTime: pickupTime ?? this.pickupTime,
      pickupCoords: pickupCoords ?? this.pickupCoords,
    );
  }
}

final class AirportBookingError extends AirportBookingState {
  final String message;
  AirportBookingError(this.message);
}

// Models
