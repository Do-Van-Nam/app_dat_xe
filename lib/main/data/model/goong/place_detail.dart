// place_detail.dart — Goong Place Detail Model

class GoongPlaceDetail {
  final String placeId;
  final String formattedAddress;
  final String name;
  final GoongGeometry? geometry;

  const GoongPlaceDetail({
    required this.placeId,
    required this.formattedAddress,
    required this.name,
    this.geometry,
  });

  factory GoongPlaceDetail.fromJson(Map<String, dynamic> json) {
    return GoongPlaceDetail(
      placeId: json['place_id'] as String? ?? '',
      formattedAddress: json['formatted_address'] as String? ?? '',
      name: json['name'] as String? ?? '',
      geometry: json['geometry'] != null
          ? GoongGeometry.fromJson(json['geometry'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'place_id': placeId,
      'formatted_address': formattedAddress,
      'name': name,
      if (geometry != null) 'geometry': geometry!.toJson(),
    };
  }
}

// ============================================================
// Geometry Info
// ============================================================

class GoongGeometry {
  final GoongLocationCoords? location;

  const GoongGeometry({
    this.location,
  });

  factory GoongGeometry.fromJson(Map<String, dynamic> json) {
    return GoongGeometry(
      location: json['location'] != null
          ? GoongLocationCoords.fromJson(
              json['location'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (location != null) 'location': location!.toJson(),
    };
  }
}

// ============================================================
// Lat Lng Coordinates
// ============================================================

class GoongLocationCoords {
  final double lat;
  final double lng;

  const GoongLocationCoords({
    required this.lat,
    required this.lng,
  });

  factory GoongLocationCoords.fromJson(Map<String, dynamic> json) {
    return GoongLocationCoords(
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}
