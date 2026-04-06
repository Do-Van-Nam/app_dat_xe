part of 'rate_trip_bloc.dart';

abstract class RateTripEvent extends Equatable {
  const RateTripEvent();

  @override
  List<Object?> get props => [];
}

/// Page initialised – load trip summary + review from repository.
class RateTripLoaded extends RateTripEvent {
  const RateTripLoaded();
}

/// User taps "XÁC NHẬN & SẴN SÀNG".
class RateTripConfirmTapped extends RateTripEvent {
  const RateTripConfirmTapped();
}
