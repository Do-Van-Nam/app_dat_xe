part of 'trip_detail_bloc.dart';

@immutable
sealed class TripDetailState {}

final class TripDetailInitial extends TripDetailState {}

final class TripDetailLoading extends TripDetailState {}

final class TripDetailLoaded extends TripDetailState {
  final bool isCompleted;
  final String driverName;
  final String vehicleInfo;
  final double rating;
  final int totalTrips;
  final String pickupAddress;
  final String pickupTime;
  final String destinationAddress;
  final String destinationTime;
  final double distance;
  final int durationMinutes;
  final int baseFare;
  final int serviceFee;
  final int discount;
  final int totalAmount;

  TripDetailLoaded({
    required this.isCompleted,
    required this.driverName,
    required this.vehicleInfo,
    required this.rating,
    required this.totalTrips,
    required this.pickupAddress,
    required this.pickupTime,
    required this.destinationAddress,
    required this.destinationTime,
    required this.distance,
    required this.durationMinutes,
    required this.baseFare,
    required this.serviceFee,
    required this.discount,
    required this.totalAmount,
  });
}

final class TripDetailError extends TripDetailState {
  final String message;
  TripDetailError(this.message);
}
