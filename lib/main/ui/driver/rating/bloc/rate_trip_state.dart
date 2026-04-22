part of 'rate_trip_bloc.dart';

enum RateTripStatus { initial, loading, confirming, confirmed, error }

class RateTripState extends Equatable {
  const RateTripState({
    this.status = RateTripStatus.initial,
    this.trip,
    this.errorMessage,
  });

  final RateTripStatus status;
  final RideIncomeSummary? trip;
  final UniqueError? errorMessage;

  RateTripState copyWith({
    RateTripStatus? status,
    RideIncomeSummary? trip,
    UniqueError? errorMessage,
  }) {
    return RateTripState(
      status: status ?? this.status,
      trip: trip ?? this.trip,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, trip, errorMessage];
}
