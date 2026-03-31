abstract class AirportBookingEvent {}

class LoadDataEvent extends AirportBookingEvent {}

class SelectTripTypeEvent extends AirportBookingEvent {
  final bool isToAirport; // true: đi đến sân bay
  SelectTripTypeEvent(this.isToAirport);
}

class SelectCarEvent extends AirportBookingEvent {
  final int index;
  SelectCarEvent(this.index);
}
