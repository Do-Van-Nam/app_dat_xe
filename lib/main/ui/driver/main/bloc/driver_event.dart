part of 'driver_bloc.dart';

abstract class DriverEvent extends Equatable {
  const DriverEvent();
  @override
  List<Object?> get props => [];
}

/// Toggle driver online/offline.
class ToggleOnlineStatus extends DriverEvent {
  const ToggleOnlineStatus();
}

/// A new ride offer arrived.
class NewRideArrived extends DriverEvent {
  final Ride offer;
  const NewRideArrived(this.offer);
  @override
  List<Object?> get props => [offer];
}

/// Customer cancellation requested.
class RideCancellationRequested extends DriverEvent {
  final Ride offer;
  const RideCancellationRequested(this.offer);
  @override
  List<Object?> get props => [offer];
}

/// Customer cancellation requested.
class CustomerCancel extends DriverEvent {
  final Ride offer;
  const CustomerCancel(this.offer);
  @override
  List<Object?> get props => [offer];
}

/// Driver accepts the incoming ride.
class RideAccepted extends DriverEvent {
  const RideAccepted();
}

/// Driver rejects / skips the incoming ride.
class RideRejected extends DriverEvent {
  const RideRejected();
}

/// Countdown ticked (-1 second).
class CountdownTicked extends DriverEvent {
  final int remaining;
  const CountdownTicked(this.remaining);
  @override
  List<Object?> get props => [remaining];
}

/// Driver has arrived at pickup point.
class ArrivedAtPickup extends DriverEvent {
  const ArrivedAtPickup();
}

/// Driver starts the trip.
class TripStarted extends DriverEvent {
  const TripStarted();
}

/// Driver has arrived at destination.
class ArrivedAtDestination extends DriverEvent {
  const ArrivedAtDestination();
}

/// Trip completed – back to online idle.
class TripCompleted extends DriverEvent {
  const TripCompleted();
}

/// Bottom nav tab changed.
class NavTabChanged extends DriverEvent {
  final NavTab tab;
  const NavTabChanged(this.tab);
  @override
  List<Object?> get props => [tab];
}

/// SOS tapped.
class SosTapped extends DriverEvent {
  const SosTapped();
}

/// Chat / call tapped.
class ChatTapped extends DriverEvent {
  const ChatTapped();
}

class CallTapped extends DriverEvent {
  const CallTapped();
}

class DebugChangeScreen extends DriverEvent {
  final DriverScreen screen;
  const DebugChangeScreen(this.screen);
  @override
  List<Object?> get props => [screen];
}
