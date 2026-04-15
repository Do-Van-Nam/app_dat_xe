class PointWallet {
  final int currentBalance;
  final int totalEarned;
  final int totalUsed;

  PointWallet({
    required this.currentBalance,
    required this.totalEarned,
    required this.totalUsed,
  });

  // Factory từ JSON (từ API)
  factory PointWallet.fromJson(Map<String, dynamic> json) {
    return PointWallet(
      currentBalance: json['current_balance'] ?? 0,
      totalEarned: json['total_earned'] ?? 0,
      totalUsed: json['total_used'] ?? 0,
    );
  }

  // CopyWith (rất hữu ích khi dùng Bloc hoặc State Management)
  PointWallet copyWith({
    int? currentBalance,
    int? totalEarned,
    int? totalUsed,
  }) {
    return PointWallet(
      currentBalance: currentBalance ?? this.currentBalance,
      totalEarned: totalEarned ?? this.totalEarned,
      totalUsed: totalUsed ?? this.totalUsed,
    );
  }

  // To JSON (nếu cần gửi lên server)
  Map<String, dynamic> toJson() {
    return {
      'current_balance': currentBalance,
      'total_earned': totalEarned,
      'total_used': totalUsed,
    };
  }

  // Model rỗng (initial state)
  factory PointWallet.empty() => PointWallet(
        currentBalance: 0,
        totalEarned: 0,
        totalUsed: 0,
      );
}
