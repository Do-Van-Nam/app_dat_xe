num? parseNum(dynamic value) {
  if (value == null) return null;
  if (value is num) return value;
  if (value is String) return num.tryParse(value);
  return null;
}

class Ride {
  final num? id;
  final num? rideId;
  final num? customerId;
  final num? driverId;
  final String? pickupAddress;
  final num? pickupLat;
  final num? pickupLng;
  final String? destinationAddress;
  final num? destinationLat;
  final num? destinationLng;
  final num? distance;
  final num? duration;
  final num? vehicleType;
  final num? status;
  final num? basePrice;
  final num? distancePrice;
  final num? totalPrice;
  final num? voucherId;
  final String? voucherCode;
  final num? discountAmount;
  final bool? isPaid;
  final String? cancelReason;
  final num? cancellationFee;
  final num? timeFare;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final num? trackingStatus;
  final DateTime? driverAssignedAt;
  final DateTime? driverArrivedAt;
  final DateTime? trackingLastPingAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final num? serviceFee;
  final num? driverEarnings;
  final num? rideType;
  final DateTime? travelDate;
  final String? travelTime;
  final num? airportId;
  final num? airportDirection;
  final Map<String, dynamic>? driver;
  final String? statusLabel;
  final String? vehicleTypeLabel;
  final String? rideTypeLabel;
  final Map<String, dynamic>? driverInfo;

  Ride({
    this.id,
    this.rideId,
    this.customerId,
    this.driverId,
    this.pickupAddress,
    this.pickupLat,
    this.pickupLng,
    this.destinationAddress,
    this.destinationLat,
    this.destinationLng,
    this.distance,
    this.duration,
    this.vehicleType,
    this.status,
    this.basePrice,
    this.distancePrice,
    this.totalPrice,
    this.voucherId,
    this.voucherCode,
    this.discountAmount,
    this.isPaid,
    this.cancelReason,
    this.cancellationFee,
    this.timeFare,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.trackingStatus,
    this.driverAssignedAt,
    this.driverArrivedAt,
    this.trackingLastPingAt,
    this.startedAt,
    this.completedAt,
    this.serviceFee,
    this.driverEarnings,
    this.rideType,
    this.travelDate,
    this.travelTime,
    this.airportId,
    this.airportDirection,
    this.driver,
    this.statusLabel,
    this.vehicleTypeLabel,
    this.rideTypeLabel,
    this.driverInfo,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: parseNum(json['id']),
      rideId: parseNum(json['ride_id']),
      customerId: parseNum(json['customer_id']),
      driverId: parseNum(json['driver_id']),
      pickupAddress: json['pickup_address'],
      pickupLat: parseNum(json['pickup_lat']),
      pickupLng: parseNum(json['pickup_lng']),
      destinationAddress: json['destination_address'],
      destinationLat: parseNum(json['destination_lat']),
      destinationLng: parseNum(json['destination_lng']),
      distance: parseNum(json['distance']),
      duration: parseNum(json['duration']),
      vehicleType: parseNum(json['vehicle_type']),
      status: parseNum(json['status']),
      basePrice: parseNum(json['base_price']),
      distancePrice: parseNum(json['distance_price']),
      totalPrice: parseNum(json['total_price']),
      voucherId: parseNum(json['voucher_id']),
      voucherCode: json['voucher_code'],
      discountAmount: parseNum(json['discount_amount']),
      isPaid: json['is_paid'],
      cancelReason: json['cancel_reason'],
      cancellationFee: parseNum(json['cancellation_fee']),
      timeFare: parseNum(json['time_fare']),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      trackingStatus: parseNum(json['tracking_status']),
      driverAssignedAt: json['driver_assigned_at'] != null
          ? DateTime.tryParse(json['driver_assigned_at'])
          : null,
      driverArrivedAt: json['driver_arrived_at'] != null
          ? DateTime.tryParse(json['driver_arrived_at'])
          : null,
      trackingLastPingAt: json['tracking_last_ping_at'] != null
          ? DateTime.tryParse(json['tracking_last_ping_at'])
          : null,
      startedAt: json['started_at'] != null
          ? DateTime.tryParse(json['started_at'])
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'])
          : null,
      serviceFee: parseNum(json['service_fee']),
      driverEarnings: parseNum(json['driver_earnings']),
      rideType: parseNum(json['ride_type']),
      travelDate: json['travel_date'] != null
          ? DateTime.tryParse(json['travel_date'])
          : null,
      travelTime: json['travel_time'],
      airportId: parseNum(json['airport_id']),
      airportDirection: parseNum(json['airport_direction']),
      driver: json['driver'],
      statusLabel: json['status_label'],
      vehicleTypeLabel: json['vehicle_type_label'],
      rideTypeLabel: json['ride_type_label'],
      driverInfo: json['driver_info'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ride_id': rideId,
      'customer_id': customerId,
      'driver_id': driverId,
      'pickup_address': pickupAddress,
      'pickup_lat': pickupLat,
      'pickup_lng': pickupLng,
      'destination_address': destinationAddress,
      'destination_lat': destinationLat,
      'destination_lng': destinationLng,
      'distance': distance,
      'duration': duration,
      'vehicle_type': vehicleType,
      'status': status,
      'base_price': basePrice,
      'distance_price': distancePrice,
      'total_price': totalPrice,
      'voucher_id': voucherId,
      'voucher_code': voucherCode,
      'discount_amount': discountAmount,
      'is_paid': isPaid,
      'cancel_reason': cancelReason,
      'cancellation_fee': cancellationFee,
      'time_fare': timeFare,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'tracking_status': trackingStatus,
      'driver_assigned_at': driverAssignedAt?.toIso8601String(),
      'driver_arrived_at': driverArrivedAt?.toIso8601String(),
      'tracking_last_ping_at': trackingLastPingAt?.toIso8601String(),
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'service_fee': serviceFee,
      'driver_earnings': driverEarnings,
      'ride_type': rideType,
      'travel_date': travelDate?.toIso8601String(),
      'travel_time': travelTime,
      'airport_id': airportId,
      'airport_direction': airportDirection,
      'driver': driver,
      'status_label': statusLabel,
      'vehicle_type_label': vehicleTypeLabel,
      'ride_type_label': rideTypeLabel,
      'driver_info': driverInfo,
    };
  }
}
