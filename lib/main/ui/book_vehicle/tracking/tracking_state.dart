part of 'tracking_bloc.dart';

@immutable
sealed class TrackingState {}

final class TrackingInitial extends TrackingState {}

final class TrackingLoading extends TrackingState {}

final class TrackingLoaded extends TrackingState {
  final String driverName;
  final String vehiclePlate;
  final String vehicleName;
  final double rating;
  final String arrivalTime;
  final double distance;
  final int discountedPrice;
  final int originalPrice;
  final String pickupAddress;
  final String destinationAddress;

  TrackingLoaded({
    required this.driverName,
    required this.vehiclePlate,
    required this.vehicleName,
    required this.rating,
    required this.arrivalTime,
    required this.distance,
    required this.discountedPrice,
    required this.originalPrice,
    required this.pickupAddress,
    required this.destinationAddress,
  });
}

final class TrackingError extends TrackingState {
  final String message;
  TrackingError(this.message);
}
