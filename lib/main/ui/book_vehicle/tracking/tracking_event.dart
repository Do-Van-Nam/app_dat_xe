part of 'tracking_bloc.dart';

@immutable
sealed class TrackingEvent {}

class LoadTrackingDataEvent extends TrackingEvent {}

class CancelRideEvent extends TrackingEvent {}
