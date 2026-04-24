part of 'scheduled_ride_bloc.dart';

abstract class ScheduledRideEvent extends Equatable {
  const ScheduledRideEvent();

  @override
  List<Object?> get props => [];
}

class ScheduledRideLoadRequested extends ScheduledRideEvent {
  const ScheduledRideLoadRequested();
}

class ScheduledRideRefreshRequested extends ScheduledRideEvent {
  const ScheduledRideRefreshRequested();
}

class ScheduledRideTabChanged extends ScheduledRideEvent {
  const ScheduledRideTabChanged(this.index);
  final int index;

  @override
  List<Object?> get props => [index];
}

class ScheduledRideFilterChanged extends ScheduledRideEvent {
  const ScheduledRideFilterChanged(this.filter);
  final TripFilter filter;

  @override
  List<Object?> get props => [filter];
}

class ScheduledRideFilterReset extends ScheduledRideEvent {
  const ScheduledRideFilterReset();
}

class ScheduledRideAcceptTrip extends ScheduledRideEvent {
  const ScheduledRideAcceptTrip(this.tripId);
  final String tripId;

  @override
  List<Object?> get props => [tripId];
}

class ScheduledRideCancelTrip extends ScheduledRideEvent {
  const ScheduledRideCancelTrip(this.tripId);
  final String tripId;

  @override
  List<Object?> get props => [tripId];
}
