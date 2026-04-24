part of 'interprovince_ride_bloc.dart';

abstract class InterprovinceRideEvent {}

class LoadInitialData extends InterprovinceRideEvent {}

class SelectVehicleType extends InterprovinceRideEvent {
  final int vehicleType;
  SelectVehicleType(this.vehicleType);
}

class ChangeDate extends InterprovinceRideEvent {
  final DateTime newDate;
  ChangeDate(this.newDate);
}

class ChangePickupTime extends InterprovinceRideEvent {
  final TimeOfDay newTime;
  ChangePickupTime(this.newTime);
}

class SavePickupPlaceIdEvent extends InterprovinceRideEvent {
  final String placeId;
  final String address;
  SavePickupPlaceIdEvent(this.placeId, this.address);
}

class SaveDestinationPlaceIdEvent extends InterprovinceRideEvent {
  final String placeId;
  final String address;
  SaveDestinationPlaceIdEvent(this.placeId, this.address);
}

class FetchCurrentLocationEvent extends InterprovinceRideEvent {}

class FetchVehiclesEvent extends InterprovinceRideEvent {}

class BookInterprovinceRideEvent extends InterprovinceRideEvent {}
