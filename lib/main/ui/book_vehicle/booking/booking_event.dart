part of 'booking_bloc.dart';

@immutable
sealed class BookingEvent {}

class LoadBookingOptionsEvent extends BookingEvent {}

class LoadInitialBookingData extends BookingEvent {
  final CreateRideRequest request;

  LoadInitialBookingData(this.request);
}

class SelectVehicleEvent extends BookingEvent {
  final String vehicleId;
  final CreateRideRequest request;
  SelectVehicleEvent(this.vehicleId, this.request);
}

class ApplyPromoCodeEvent extends BookingEvent {
  final String code;
  ApplyPromoCodeEvent(this.code);
}

class UnApplyPromoCodeEvent extends BookingEvent {
  final String code;
  UnApplyPromoCodeEvent(this.code);
}

class CreateRideEvent extends BookingEvent {
  final CreateRideRequest request;
  CreateRideEvent(this.request);
}

class CreateRideRequest {
  final String pickupAddress;
  final String pickupLat;
  final String pickupLng;
  final String destinationAddress;
  final String destinationLat;
  final String destinationLng;
  final int vehicleType;

  CreateRideRequest({
    required this.pickupAddress,
    required this.pickupLat,
    required this.pickupLng,
    required this.destinationAddress,
    required this.destinationLat,
    required this.destinationLng,
    required this.vehicleType,
  });
  CreateRideRequest copyWith({
    String? pickupAddress,
    String? pickupLat,
    String? pickupLng,
    String? destinationAddress,
    String? destinationLat,
    String? destinationLng,
    int? vehicleType,
  }) {
    return CreateRideRequest(
      pickupAddress: pickupAddress ?? this.pickupAddress,
      pickupLat: pickupLat ?? this.pickupLat,
      pickupLng: pickupLng ?? this.pickupLng,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      destinationLat: destinationLat ?? this.destinationLat,
      destinationLng: destinationLng ?? this.destinationLng,
      vehicleType: vehicleType ?? this.vehicleType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pickup_address': pickupAddress,
      'pickup_lat': pickupLat,
      'pickup_lng': pickupLng,
      'destination_address': destinationAddress,
      'destination_lat': destinationLat,
      'destination_lng': destinationLng,
      'vehicle_type': vehicleType,
    };
  }
}

class GetVehiclesEvent extends BookingEvent {
  final CreateRideRequest request;
  GetVehiclesEvent(this.request);
}

class GetPriceEvent extends BookingEvent {
  final CreateRideRequest request;
  GetPriceEvent(this.request);
}

class ConfirmRideEvent extends BookingEvent {
  final int rideId;
  final int expectedPrice;
  final Function onSuccess;
  ConfirmRideEvent(this.rideId, this.expectedPrice, this.onSuccess);
}

class CancelRideEvent extends BookingEvent {
  final int rideId;
  final String cancelReason;
  CancelRideEvent(this.rideId, this.cancelReason);
}
