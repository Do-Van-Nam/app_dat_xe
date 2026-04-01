part of 'airport_booking_bloc.dart';

@immutable
sealed class AirportBookingState {}

final class AirportBookingInitial extends AirportBookingState {}

final class AirportBookingLoading extends AirportBookingState {}

final class AirportBookingLoaded extends AirportBookingState {
  final int selectedTripType; // 0: Đi đến, 1: Đón từ
  final List<Airport> nearbyAirports;
  final List<VehicleOption> vehicles;
  final String selectedVehicleId;

  AirportBookingLoaded({
    this.selectedTripType = 0,
    required this.nearbyAirports,
    required this.vehicles,
    this.selectedVehicleId = "taxi",
  });
}

final class AirportBookingError extends AirportBookingState {
  final String message;
  AirportBookingError(this.message);
}

// Models
class Airport {
  final String name;
  final String subtitle;
  final String distance;

  Airport({required this.name, required this.subtitle, required this.distance});
}

class VehicleOption {
  final String id;
  final String name;
  final int price;
  final String passengers;
  final String luggage;
  final String tag;
  final Color tagColor;
  final String imageUrl;

  VehicleOption({
    required this.id,
    required this.name,
    required this.price,
    required this.passengers,
    required this.luggage,
    required this.tag,
    required this.tagColor,
    required this.imageUrl,
  });
}
