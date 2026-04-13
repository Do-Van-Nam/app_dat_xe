class Ride {
  final int? id;
  final int? customerId;
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
  final String? discountAmount;
  final bool? isPaid;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Ride({
    this.id,
    this.customerId,
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
    this.discountAmount,
    this.isPaid,
    this.createdAt,
    this.updatedAt,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'],
      customerId: json['customer_id'],
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
      discountAmount: json['discount_amount'],
      isPaid: json['is_paid'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
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
      'discount_amount': discountAmount,
      'is_paid': isPaid,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
