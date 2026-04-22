class RideIncomeSummary {
  final String? rideId;
  final Journey? journey;
  final FareDetails? fareDetails;
  final Earnings? earnings;

  RideIncomeSummary({
    this.rideId,
    this.journey,
    this.fareDetails,
    this.earnings,
  });

  factory RideIncomeSummary.fromJson(Map<String, dynamic> json) {
    return RideIncomeSummary(
      rideId: json['ride_id'],
      journey:
          json['journey'] != null ? Journey.fromJson(json['journey']) : null,
      fareDetails: json['fare_details'] != null
          ? FareDetails.fromJson(json['fare_details'])
          : null,
      earnings:
          json['earnings'] != null ? Earnings.fromJson(json['earnings']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ride_id': rideId,
      'journey': journey?.toJson(),
      'fare_details': fareDetails?.toJson(),
      'earnings': earnings?.toJson(),
    };
  }
}

class Journey {
  final String? pickup;
  final String? destination;
  final num? distanceKm;
  final num? durationMin;

  Journey({
    this.pickup,
    this.destination,
    this.distanceKm,
    this.durationMin,
  });

  factory Journey.fromJson(Map<String, dynamic> json) {
    return Journey(
      pickup: json['pickup'],
      destination: json['destination'],
      distanceKm: json['distance_km'],
      durationMin: json['duration_min'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pickup': pickup,
      'destination': destination,
      'distance_km': distanceKm,
      'duration_min': durationMin,
    };
  }
}

class FareDetails {
  final num? baseFare;
  final num? distanceFare;
  final num? timeFare;
  final num? discount;
  final num? totalFare;

  FareDetails({
    this.baseFare,
    this.distanceFare,
    this.timeFare,
    this.discount,
    this.totalFare,
  });

  factory FareDetails.fromJson(Map<String, dynamic> json) {
    return FareDetails(
      baseFare: json['base_fare'],
      distanceFare: json['distance_fare'],
      timeFare: json['time_fare'],
      discount: json['discount'],
      totalFare: json['total_fare'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base_fare': baseFare,
      'distance_fare': distanceFare,
      'time_fare': timeFare,
      'discount': discount,
      'total_fare': totalFare,
    };
  }
}

class Earnings {
  final num? serviceFee;
  final num? driverEarnings;

  Earnings({
    this.serviceFee,
    this.driverEarnings,
  });

  factory Earnings.fromJson(Map<String, dynamic> json) {
    return Earnings(
      serviceFee: json['service_fee'],
      driverEarnings: json['driver_earnings'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_fee': serviceFee,
      'driver_earnings': driverEarnings,
    };
  }
}
