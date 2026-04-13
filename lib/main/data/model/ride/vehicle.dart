class Vehicle {
  final int? vehicleType;
  final String? name;
  final String? description;
  final int? capacity;
  final num? estimatedFare;
  final String? estimatedWaitTime;
  final bool? isAvailable;

  Vehicle({
    this.vehicleType,
    this.name,
    this.description,
    this.capacity,
    this.estimatedFare,
    this.estimatedWaitTime,
    this.isAvailable,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      vehicleType: json['vehicle_type'],
      name: json['name'],
      description: json['description'],
      capacity: json['capacity'],
      estimatedFare: json['estimated_fare'],
      estimatedWaitTime: json['estimated_wait_time'],
      isAvailable: json['is_available'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicle_type': vehicleType,
      'name': name,
      'description': description,
      'capacity': capacity,
      'estimated_fare': estimatedFare,
      'estimated_wait_time': estimatedWaitTime,
      'is_available': isAvailable,
    };
  }
}
