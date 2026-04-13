class Price {
  final int? rideId;
  final num? distanceKm;
  final num? durationMinutes;
  final FareBreakdown? fareBreakdown;
  final String? voucherCode;
  final num? discountAmount;
  final num? finalFare;

  Price({
    this.rideId,
    this.distanceKm,
    this.durationMinutes,
    this.fareBreakdown,
    this.voucherCode,
    this.discountAmount,
    this.finalFare,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      rideId: json['ride_id'],
      distanceKm: json['distance_km'],
      durationMinutes: json['duration_minutes'],
      fareBreakdown: json['fare_breakdown'] != null
          ? FareBreakdown.fromJson(json['fare_breakdown'])
          : null,
      voucherCode: json['voucher_code'],
      discountAmount: json['discount_amount'],
      finalFare: json['final_fare'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ride_id': rideId,
      'distance_km': distanceKm,
      'duration_minutes': durationMinutes,
      'fare_breakdown': fareBreakdown?.toJson(),
      'voucher_code': voucherCode,
      'discount_amount': discountAmount,
      'final_fare': finalFare,
    };
  }
}

class FareBreakdown {
  final num? baseFare;
  final num? distanceFare;
  final num? timeFare;
  final num? surgeMultiplier;
  final num? originalFare;

  FareBreakdown({
    this.baseFare,
    this.distanceFare,
    this.timeFare,
    this.surgeMultiplier,
    this.originalFare,
  });

  factory FareBreakdown.fromJson(Map<String, dynamic> json) {
    return FareBreakdown(
      baseFare: json['base_fare'],
      distanceFare: json['distance_fare'],
      timeFare: json['time_fare'],
      surgeMultiplier: json['surge_multiplier'],
      originalFare: json['original_fare'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base_fare': baseFare,
      'distance_fare': distanceFare,
      'time_fare': timeFare,
      'surge_multiplier': surgeMultiplier,
      'original_fare': originalFare,
    };
  }
}
