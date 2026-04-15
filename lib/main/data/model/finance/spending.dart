class SpendingModel {
  final String rangeLabel;
  final int totalAmount;
  final int totalCount;
  final List<SpendingBreakdown> breakdown;

  SpendingModel({
    required this.rangeLabel,
    required this.totalAmount,
    required this.totalCount,
    required this.breakdown,
  });

  // Factory từ JSON (từ API)
  factory SpendingModel.fromJson(Map<String, dynamic> json) {
    return SpendingModel(
      rangeLabel: json['range_label'] ?? '',
      totalAmount: json['total_amount'] ?? 0,
      totalCount: json['total_count'] ?? 0,
      breakdown: (json['breakdown'] as List<dynamic>? ?? [])
          .map((item) =>
              SpendingBreakdown.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  // CopyWith (rất hữu ích khi dùng Bloc hoặc State Management)
  SpendingModel copyWith({
    String? rangeLabel,
    int? totalAmount,
    int? totalCount,
    List<SpendingBreakdown>? breakdown,
  }) {
    return SpendingModel(
      rangeLabel: rangeLabel ?? this.rangeLabel,
      totalAmount: totalAmount ?? this.totalAmount,
      totalCount: totalCount ?? this.totalCount,
      breakdown: breakdown ?? this.breakdown,
    );
  }

  // To JSON (nếu cần gửi lên server)
  Map<String, dynamic> toJson() {
    return {
      'range_label': rangeLabel,
      'total_amount': totalAmount,
      'total_count': totalCount,
      'breakdown': breakdown.map((e) => e.toJson()).toList(),
    };
  }

  // Model rỗng (initial state)
  factory SpendingModel.empty() => SpendingModel(
        rangeLabel: '',
        totalAmount: 0,
        totalCount: 0,
        breakdown: [],
      );
}

class SpendingBreakdown {
  final String service;
  final int amount;
  final int count;

  SpendingBreakdown({
    required this.service,
    required this.amount,
    required this.count,
  });

  factory SpendingBreakdown.fromJson(Map<String, dynamic> json) {
    return SpendingBreakdown(
      service: json['service'] ?? '',
      amount: json['amount'] ?? 0,
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service': service,
      'amount': amount,
      'count': count,
    };
  }
}
