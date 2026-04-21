part of 'tracking_bloc.dart';

@immutable
sealed class TrackingEvent {}

class LoadTrackingDataEvent extends TrackingEvent {}

class CancelRideEvent extends TrackingEvent {}

class CancelRideRequestEvent extends TrackingEvent {}

class ChangeTrackingStatusEvent extends TrackingEvent {
  final TrackingStatus status;
  ChangeTrackingStatusEvent({required this.status});
}
