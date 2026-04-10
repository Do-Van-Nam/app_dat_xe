class User {
  final int id;
  final String phone;
  final String? email;
  final int role;
  final String? roleLabel;
  final Detail? avatar;
  final Detail? fullName;
  final Gender? gender;
  final String? genderLabel;
  final Detail? address;
  final Detail? citizenId;
  final bool isVerified;
  final bool isPhoneVerified;
  final bool isActive;
  final DateTime createdAt;
  final CustomerSpecific? customerSpecific;
  final DriverSpecific? driverSpecific;
  final MerchantSpecific? merchantSpecific;

  User({
    required this.id,
    required this.phone,
    this.email,
    required this.role,
    this.roleLabel,
    this.avatar,
    this.fullName,
    this.gender,
    this.genderLabel,
    this.address,
    this.citizenId,
    required this.isVerified,
    required this.isPhoneVerified,
    required this.isActive,
    required this.createdAt,
    this.customerSpecific,
    this.driverSpecific,
    this.merchantSpecific,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      phone: json['phone']?.toString() ?? '',
      email: json['email'] != null
          ? (json['email'] is String
              ? json['email']
              : json['email']['value']?.toString())
          : null,
      role: json['role'] is int
          ? json['role']
          : int.tryParse(json['role'].toString()) ?? 0,
      roleLabel: json['role_label']?.toString(),
      avatar: json['avatar'] != null ? Detail.fromJson(json['avatar']) : null,
      fullName:
          json['full_name'] != null ? Detail.fromJson(json['full_name']) : null,
      gender: json['gender'] != null ? Gender.fromJson(json['gender']) : null,
      genderLabel: json['gender_label']?.toString(),
      address:
          json['address'] != null ? Detail.fromJson(json['address']) : null,
      citizenId: json['citizen_id'] != null
          ? Detail.fromJson(json['citizen_id'])
          : null,
      isVerified: json['is_verified'] == true,
      isPhoneVerified: json['is_phone_verified'] == true,
      isActive: json['is_active'] == true,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      customerSpecific: json['customer_specific'] != null
          ? CustomerSpecific.fromJson(json['customer_specific'])
          : null,
      driverSpecific: json['driver_specific'] != null
          ? DriverSpecific.fromJson(json['driver_specific'])
          : null,
      merchantSpecific: json['merchant_specific'] != null
          ? MerchantSpecific.fromJson(json['merchant_specific'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'email': email,
      'role': role,
      'role_label': roleLabel,
      'avatar': avatar?.toJson(),
      'full_name': fullName?.toJson(),
      'gender': gender?.toJson(),
      'gender_label': genderLabel,
      'address': address?.toJson(),
      'citizen_id': citizenId?.toJson(),
      'is_verified': isVerified,
      'is_phone_verified': isPhoneVerified,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'customer_specific': customerSpecific?.toJson(),
      'driver_specific': driverSpecific?.toJson(),
      'merchant_specific': merchantSpecific?.toJson(),
    };
  }

  // Helper methods for accessing field values
  String get displayName => fullName?.value ?? phone;
  String get displayEmail => email ?? 'Chưa cập nhật';
  String get displayGender => gender?.display ?? 'Chưa cập nhật';
  String get displayAddress => address?.display ?? 'Chưa cập nhật';
  String get displayCitizenId => citizenId?.display ?? 'Chưa cập nhật';
  String? get avatarUrl => avatar?.value;
  String? get birthday => customerSpecific?.birthday?.value;
}

class Detail {
  final String value;
  final String display;
  final String field;
  final bool isPending;

  Detail({
    required this.value,
    required this.display,
    required this.field,
    required this.isPending,
  });

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      value: json['value']?.toString() ?? '',
      display: json['display']?.toString() ?? '',
      field: json['field']?.toString() ?? '',
      isPending: json['is_pending'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'display': display,
      'field': field,
      'is_pending': isPending,
    };
  }
}

class Gender {
  final int value;
  final String display;
  final String field;
  final bool isPending;

  Gender({
    required this.value,
    required this.display,
    required this.field,
    required this.isPending,
  });

  factory Gender.fromJson(Map<String, dynamic> json) {
    return Gender(
      value: json['value'] ?? 1,
      display: json['display']?.toString() ?? '',
      field: json['field']?.toString() ?? '',
      isPending: json['is_pending'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'display': display,
      'field': field,
      'is_pending': isPending,
    };
  }
}

class CitizenId {
  final String value;
  final String display;
  final String field;

  CitizenId({
    required this.value,
    required this.display,
    required this.field,
  });

  factory CitizenId.fromJson(Map<String, dynamic> json) {
    return CitizenId(
      value: json['value']?.toString() ?? '',
      display: json['display']?.toString() ?? '',
      field: json['field']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'display': display,
      'field': field,
    };
  }
}

class CustomerSpecific {
  final Detail? birthday;

  CustomerSpecific({
    this.birthday,
  });

  factory CustomerSpecific.fromJson(Map<String, dynamic> json) {
    return CustomerSpecific(
      birthday:
          json['birthday'] != null ? Detail.fromJson(json['birthday']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'birthday': birthday,
    };
  }
}

class DriverSpecific {
  DriverSpecific();

  factory DriverSpecific.fromJson(Map<String, dynamic> json) {
    return DriverSpecific();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}

class MerchantSpecific {
  MerchantSpecific();

  factory MerchantSpecific.fromJson(Map<String, dynamic> json) {
    return MerchantSpecific();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
