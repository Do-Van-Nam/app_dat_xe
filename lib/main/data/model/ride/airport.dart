class Airport {
  final int? id;
  final String? name;
  final String? code;
  final double? lat;
  final double? lng;

  Airport({
    this.id,
    this.name,
    this.code,
    this.lat,
    this.lng,
  });

  factory Airport.fromJson(Map<String, dynamic> json) {
    return Airport(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'lat': lat,
      'lng': lng,
    };
  }
}
