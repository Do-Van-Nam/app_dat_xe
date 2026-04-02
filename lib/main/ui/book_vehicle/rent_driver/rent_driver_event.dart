part of 'rent_driver_bloc.dart';

abstract class RentDriverEvent extends Equatable {
  const RentDriverEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when the map finishes locating the user.
class RentDriverLocationDetected extends RentDriverEvent {
  const RentDriverLocationDetected({
    required this.pickupName,
    required this.pickupAddress,
  });
  final String pickupName;
  final String pickupAddress;

  @override
  List<Object?> get props => [pickupName, pickupAddress];
}

/// Triggered when location detection fails.
class RentDriverLocationFailed extends RentDriverEvent {
  const RentDriverLocationFailed(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Triggered when the user types or selects a destination.
class RentDriverDestinationChanged extends RentDriverEvent {
  const RentDriverDestinationChanged(this.destination);
  final String destination;

  @override
  List<Object?> get props => [destination];
}

/// Triggered when the user taps a nearby suggestion chip.
class RentDriverSuggestionTapped extends RentDriverEvent {
  const RentDriverSuggestionTapped(this.suggestion);
  final String suggestion;

  @override
  List<Object?> get props => [suggestion];
}

/// Triggered when the user taps the destination row to open search.
class RentDriverDestinationRowTapped extends RentDriverEvent {
  const RentDriverDestinationRowTapped();
}

/// Triggered when the user taps "Tiếp tục".
class RentDriverContinueTapped extends RentDriverEvent {
  const RentDriverContinueTapped();
}

/// Triggered when the user taps the voucher / promo area.
class RentDriverPromoTapped extends RentDriverEvent {
  const RentDriverPromoTapped();
}
