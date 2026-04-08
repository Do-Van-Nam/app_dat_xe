class User {
  final int id;
  final String phone;
  final String? email;
  final int role;
  final bool isVerified;
  final bool isPhoneVerified;
  final bool isActive;
  final DateTime createdAt;

  User({
    required this.id,
    required this.phone,
    this.email,
    required this.role,
    required this.isVerified,
    required this.isPhoneVerified,
    required this.isActive,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      phone: json['phone']?.toString() ?? '',
      email: json['email'] as String?,
      role: json['role'] is int
          ? json['role']
          : int.tryParse(json['role'].toString()) ?? 0,
      isVerified: json['is_verified'] == true,
      isPhoneVerified: json['is_phone_verified'] == true,
      isActive: json['is_active'] == true,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'email': email,
      'role': role,
      'is_verified': isVerified,
      'is_phone_verified': isPhoneVerified,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
