class Ride {
  final int? id;
  final int? customerId;
  final int? driverId;
  final String? pickupAddress;
  final String? pickupLat;
  final String? pickupLng;
  final String? destinationAddress;
  final String? destinationLat;
  final String? destinationLng;
  final num? distance;
  final num? duration;
  final int? vehicleType;
  final int? status;
  final String? basePrice;
  final String? distancePrice;
  final String? totalPrice;
  final int? voucherId;
  final String? voucherCode;
  final String? discountAmount;
  final bool? isPaid;
  final String? cancelReason;
  final String? cancellationFee;
  final String? timeFare;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Ride({
    this.id,
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
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'],
      customerId: json['customer_id'],
      driverId: json['driver_id'],
      pickupAddress: json['pickup_address'],
      pickupLat: json['pickup_lat'],
      pickupLng: json['pickup_lng'],
      destinationAddress: json['destination_address'],
      destinationLat: json['destination_lat'],
      destinationLng: json['destination_lng'],
      distance: json['distance'],
      duration: json['duration'],
      vehicleType: json['vehicle_type'],
      status: json['status'],
      basePrice: json['base_price'],
      distancePrice: json['distance_price'],
      totalPrice: json['total_price'],
      voucherId: json['voucher_id'],
      voucherCode: json['voucher_code'],
      discountAmount: json['discount_amount'],
      isPaid: json['is_paid'],
      cancelReason: json['cancel_reason'],
      cancellationFee: json['cancellation_fee'],
      timeFare: json['time_fare'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
    };
  }
}
