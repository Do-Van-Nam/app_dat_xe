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

class ChatTapped extends TrackingEvent {}

class CallTapped extends TrackingEvent {}

class TrackingDriverUpdatedEvent extends TrackingEvent {
  final LatLng location;
  TrackingDriverUpdatedEvent({required this.location});
}
