part of 'tracking_bloc.dart';

@immutable
sealed class TrackingState {}

final class TrackingInitial extends TrackingState {}

final class TrackingLoading extends TrackingState {}

enum TrackingStatus {
  driverArriving,
  driverArrived,
  driverPickedUp,
  driverStarted,
  driverCompleted,
  driverRejected,
  userCancelRequested,
  userCancelFailed,
  userCancelSuccess,
}

final class TrackingLoaded extends TrackingState {
  final String driverName;
  final String vehiclePlate;
  final String vehicleName;
  final double rating;
  final String arrivalTime;
  final double distance;
  final double discountedPrice;
  final double originalPrice;
  final String pickupAddress;
  final String destinationAddress;
  final TrackingStatus status;
  final Ride ride;

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
    required this.status,
    required this.ride,
  });

  TrackingLoaded copyWith({
    String? driverName,
    String? vehiclePlate,
    String? vehicleName,
    double? rating,
    String? arrivalTime,
    double? distance,
    double? discountedPrice,
    double? originalPrice,
    String? pickupAddress,
    String? destinationAddress,
    TrackingStatus? status,
    Ride? ride,
  }) {
    return TrackingLoaded(
      driverName: driverName ?? this.driverName,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
      vehicleName: vehicleName ?? this.vehicleName,
      rating: rating ?? this.rating,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      distance: distance ?? this.distance,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      originalPrice: originalPrice ?? this.originalPrice,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      status: status ?? this.status,
      ride: ride ?? this.ride,
    );
  }
}

final class TrackingError extends TrackingState {
  final String message;
  TrackingError(this.message);
}
