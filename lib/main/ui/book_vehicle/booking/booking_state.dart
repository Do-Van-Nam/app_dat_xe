part of 'booking_bloc.dart';

@immutable
sealed class BookingState {}

final class BookingInitial extends BookingState {}

final class BookingLoading extends BookingState {}

final class BookingLoaded extends BookingState {
  final String pickupAddress;
  final String destinationAddress;
  final List<VehicleOption> vehicles;
  final String selectedVehicleId;
  final String? promoCode;
  final int totalAmount;

  BookingLoaded({
    required this.pickupAddress,
    required this.destinationAddress,
    required this.vehicles,
    this.selectedVehicleId = "car4",
    this.promoCode,
    required this.totalAmount,
  });
}

final class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}

// Model
class VehicleOption {
  final String id;
  final String name;
  final int price;
  final String time;
  final String tag; // TIẾT KIỆM, PHỔ BIẾN, GIA ĐÌNH
  final IconData icon;
  final Color? tagColor;

  VehicleOption({
    required this.id,
    required this.name,
    required this.price,
    required this.time,
    required this.tag,
    required this.icon,
    this.tagColor,
  });
}
