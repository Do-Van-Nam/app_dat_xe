class Address {
  /// Nhãn: 1=Nhà, 2=Công ty, 3=Nhà hàng yêu thích, 4=Khác
  static const int labelHome = 1;
  static const int labelCompany = 2;
  static const int labelFavoriteRestaurant = 3;
  static const int labelOther = 4;

  final int id;
  final int label;
  final String labelText;
  final String name;
  final String addressText;
  final double lat;
  final double lng;
  final String receiverName;
  final String receiverPhone;
  final String? note;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Address({
    required this.id,
    required this.label,
    required this.labelText,
    required this.name,
    required this.addressText,
    required this.lat,
    required this.lng,
    required this.receiverName,
    required this.receiverPhone,
    this.note,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] as int,
      label: json['label'] as int,
      labelText: json['label_text'] as String,
      name: json['name'] as String,
      addressText: json['address_text'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      receiverName: json['receiver_name'] as String,
      receiverPhone: json['receiver_phone'] as String,
      note: json['note'] as String?,
      isDefault: json['is_default'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'label_text': labelText,
      'name': name,
      'address_text': addressText,
      'lat': lat,
      'lng': lng,
      'receiver_name': receiverName,
      'receiver_phone': receiverPhone,
      'note': note,
      'is_default': isDefault,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Address copyWith({
    int? id,
    int? label,
    String? labelText,
    String? name,
    String? addressText,
    double? lat,
    double? lng,
    String? receiverName,
    String? receiverPhone,
    String? note,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Address(
      id: id ?? this.id,
      label: label ?? this.label,
      labelText: labelText ?? this.labelText,
      name: name ?? this.name,
      addressText: addressText ?? this.addressText,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      receiverName: receiverName ?? this.receiverName,
      receiverPhone: receiverPhone ?? this.receiverPhone,
      note: note ?? this.note,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Address && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Address(id: $id, name: $name, label: $label, isDefault: $isDefault)';
}
