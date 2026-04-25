import 'package:demo_app/main/utils/utility_fuctions.dart';

class Package {
  final String? id;
  final String? name;
  final String? description;
  final num? price;
  final int? durationDays;
  final int? serviceFeeReductionPercent;

  Package({
    this.id,
    this.name,
    this.description,
    this.price,
    this.durationDays,
    this.serviceFeeReductionPercent,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id']?.toString(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: parseNum(json['price']),
      durationDays: json['duration_days'] as int?,
      serviceFeeReductionPercent: json['service_fee_reduction_percent'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'duration_days': durationDays,
      'service_fee_reduction_percent': serviceFeeReductionPercent,
    };
  }
}
