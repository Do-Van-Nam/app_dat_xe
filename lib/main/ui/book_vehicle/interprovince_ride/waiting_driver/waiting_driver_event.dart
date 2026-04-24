part of 'waiting_driver_bloc.dart';

abstract class WaitingDriverEvent extends Equatable {
  const WaitingDriverEvent();

  @override
  List<Object?> get props => [];
}

/// Init
class WaitingDriverInit extends WaitingDriverEvent {
  const WaitingDriverInit(this.rideId);
  final String rideId;

  @override
  List<Object?> get props => [rideId];
}

/// Fired internally when the backend finds a driver.
class WaitingDriverDriverFound extends WaitingDriverEvent {
  const WaitingDriverDriverFound();
}

/// Fired internally when driver search fails.
class WaitingDriverSearchFailed extends WaitingDriverEvent {
  const WaitingDriverSearchFailed(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

/// User taps the more-options (⋯) button.
class WaitingDriverMoreOptionsTapped extends WaitingDriverEvent {
  const WaitingDriverMoreOptionsTapped();
}

/// User taps "Hủy yêu cầu".
class WaitingDriverCancelTapped extends WaitingDriverEvent {
  const WaitingDriverCancelTapped();
}

/// User confirms cancellation in the dialog.
class WaitingDriverCancelConfirmed extends WaitingDriverEvent {
  const WaitingDriverCancelConfirmed();
}
