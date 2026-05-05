import 'package:demo_app/main/data/model/ride/ride.dart';

class Tracking {
  final String? event;
  final String? message;
  final Ride? ride;
  final TrackingDriver? driver;
  final TrackingLocation? location;
  final TrackingEta? eta;
  final dynamic warning;
  final TrackingRealtime? realtime;

  Tracking({
    this.event,
    this.message,
    this.ride,
    this.driver,
    this.location,
    this.eta,
    this.warning,
    this.realtime,
  });

  factory Tracking.fromJson(Map<String, dynamic> json) {
    return Tracking(
      event: json['event']?.toString(),
      message: json['message']?.toString(),
      ride: json['ride'] != null ? Ride.fromJson(json['ride']) : null,
      driver: json['driver'] != null
          ? TrackingDriver.fromJson(json['driver'])
          : null,
      location: json['location'] != null
          ? TrackingLocation.fromJson(json['location'])
          : null,
      eta: json['eta'] != null ? TrackingEta.fromJson(json['eta']) : null,
      warning: json['warning'],
      realtime: json['realtime'] != null
          ? TrackingRealtime.fromJson(json['realtime'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event': event,
      'message': message,
      'ride': ride?.toJson(),
      'driver': driver?.toJson(),
      'location': location?.toJson(),
      'eta': eta?.toJson(),
      'warning': warning,
      'realtime': realtime?.toJson(),
    };
  }
}

class TrackingDriver {
  final String? id;
  final String? name;
  final String? phone;
  final String? vehicleNumber;
  final String? vehicleName;
  final int? vehicleType;
  final String? vehicleTypeLabel;
  final double? rating;

  TrackingDriver({
    this.id,
    this.name,
    this.phone,
    this.vehicleNumber,
    this.vehicleName,
    this.vehicleType,
    this.vehicleTypeLabel,
    this.rating,
  });

  factory TrackingDriver.fromJson(Map<String, dynamic> json) {
    return TrackingDriver(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      phone: json['phone']?.toString(),
      vehicleNumber: json['vehicle_number']?.toString(),
      vehicleName: json['vehicle_name']?.toString(),
      vehicleType: parseNum(json['vehicle_type'])?.toInt(),
      vehicleTypeLabel: json['vehicle_type_label']?.toString(),
      rating: parseNum(json['rating'])?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'vehicle_number': vehicleNumber,
      'vehicle_name': vehicleName,
      'vehicle_type': vehicleType,
      'vehicle_type_label': vehicleTypeLabel,
      'rating': rating,
    };
  }
}

class TrackingLocation {
  final double? lat;
  final double? lng;
  final String? updatedAt;
  final bool? isTrackingLost;
  final int? secondsSinceLastPing;

  TrackingLocation({
    this.lat,
    this.lng,
    this.updatedAt,
    this.isTrackingLost,
    this.secondsSinceLastPing,
  });

  factory TrackingLocation.fromJson(Map<String, dynamic> json) {
    return TrackingLocation(
      lat: parseNum(json['lat'])?.toDouble(),
      lng: parseNum(json['lng'])?.toDouble(),
      updatedAt: json['updated_at']?.toString(),
      isTrackingLost: json['is_tracking_lost'] as bool?,
      secondsSinceLastPing: parseNum(json['seconds_since_last_ping'])?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
      'updated_at': updatedAt,
      'is_tracking_lost': isTrackingLost,
      'seconds_since_last_ping': secondsSinceLastPing,
    };
  }
}

class TrackingEta {
  final int? minutes;
  final String? text;
  final int? distanceToPickupMeters;

  TrackingEta({
    this.minutes,
    this.text,
    this.distanceToPickupMeters,
  });

  factory TrackingEta.fromJson(Map<String, dynamic> json) {
    return TrackingEta(
      minutes: parseNum(json['minutes'])?.toInt(),
      text: json['text']?.toString(),
      distanceToPickupMeters:
          parseNum(json['distance_to_pickup_meters'])?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minutes': minutes,
      'text': text,
      'distance_to_pickup_meters': distanceToPickupMeters,
    };
  }
}

class TrackingRealtime {
  final String? room;
  final String? channel;

  TrackingRealtime({
    this.room,
    this.channel,
  });

  factory TrackingRealtime.fromJson(Map<String, dynamic> json) {
    return TrackingRealtime(
      room: json['room']?.toString(),
      channel: json['channel']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'room': room,
      'channel': channel,
    };
  }
}

num? parseNum(dynamic value) {
  if (value == null) return null;
  if (value is num) return value;
  if (value is String) return num.tryParse(value);
  return null;
}
