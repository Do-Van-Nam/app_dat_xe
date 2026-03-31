part of 'booking_bloc.dart';

@immutable
sealed class BookingEvent {}

class LoadBookingOptionsEvent extends BookingEvent {}

class SelectVehicleEvent extends BookingEvent {
  final String vehicleId;
  SelectVehicleEvent(this.vehicleId);
}

class ApplyPromoCodeEvent extends BookingEvent {
  final String code;
  ApplyPromoCodeEvent(this.code);
}
