part of 'interprovince_ride_bloc.dart';

abstract class InterprovinceRideEvent {}

class LoadInitialData extends InterprovinceRideEvent {}

class SelectVehicleType extends InterprovinceRideEvent {
  final int typeIndex; // 0: Xe ghép, 1: 4 chỗ, 2: 7 chỗ
  SelectVehicleType(this.typeIndex);
}

class ChangeDate extends InterprovinceRideEvent {
  final DateTime newDate;
  ChangeDate(this.newDate);
}

class ChangePickupTime extends InterprovinceRideEvent {
  final TimeOfDay newTime;
  ChangePickupTime(this.newTime);
}

class UpdateDestination extends InterprovinceRideEvent {
  final String destination;
  UpdateDestination(this.destination);
}

// Thêm các event khác: chọn điểm đón, submit tìm xe...
