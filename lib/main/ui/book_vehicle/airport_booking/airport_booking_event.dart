part of 'airport_booking_bloc.dart';

@immutable
sealed class AirportBookingEvent {}

class LoadAirportBookingEvent extends AirportBookingEvent {}

class SelectTripTypeEvent extends AirportBookingEvent {
  final int index; // 0: Đi đến sân bay, 1: Đón từ sân bay
  SelectTripTypeEvent(this.index);
}

class SelectVehicleEvent extends AirportBookingEvent {
  final int vehicleType;
  SelectVehicleEvent(this.vehicleType);
}

class SavePickupPlaceIdEvent extends AirportBookingEvent {
  final String pickupPlaceId;
  SavePickupPlaceIdEvent(this.pickupPlaceId);
}

class SelectAirportEvent extends AirportBookingEvent {
  final Airport airport;
  SelectAirportEvent(this.airport);
}

class FetchCurrentLocationEvent extends AirportBookingEvent {}

class ChangeDate extends AirportBookingEvent {
  final DateTime date;
  ChangeDate(this.date);
}

class ChangePickupTime extends AirportBookingEvent {
  final TimeOfDay time;
  ChangePickupTime(this.time);
}

class FetchVehiclesEvent extends AirportBookingEvent {}

class BookAirportRideEvent extends AirportBookingEvent {}
