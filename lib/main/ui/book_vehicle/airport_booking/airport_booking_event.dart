part of 'airport_booking_bloc.dart';

@immutable
sealed class AirportBookingEvent {}

class LoadAirportBookingEvent extends AirportBookingEvent {}

class SelectTripTypeEvent extends AirportBookingEvent {
  final int index; // 0: Đi đến sân bay, 1: Đón từ sân bay
  SelectTripTypeEvent(this.index);
}

class SelectVehicleEvent extends AirportBookingEvent {
  final String vehicleId;
  SelectVehicleEvent(this.vehicleId);
}
