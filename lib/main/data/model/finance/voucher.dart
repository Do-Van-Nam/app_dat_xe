// lib/main/data/model/finance/voucher.dart

class Voucher {
  final int? id;
  final String? code;
  final String? serviceType;
  final String? discountType;
  final num? discountValue;
  final num? minOrderAmount;
  final num? maxDiscountValue;
  final String? validUntil;
  final String? description;
  final bool? isSaved;
  final String? status;

  Voucher({
    this.id,
    this.code,
    this.serviceType,
    this.discountType,
    this.discountValue,
    this.minOrderAmount,
    this.maxDiscountValue,
    this.validUntil,
    this.description,
    this.isSaved,
    this.status,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      id: json['id'],
      code: json['code'],
      serviceType: json['service_type'],
      discountType: json['discount_type'],
      discountValue: json['discount_value'],
      minOrderAmount: json['min_order_amount'],
      maxDiscountValue: json['max_discount_value'],
      validUntil: json['valid_until'],
      description: json['description'],
      isSaved: json['is_saved'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'service_type': serviceType,
      'discount_type': discountType,
      'discount_value': discountValue,
      'min_order_amount': minOrderAmount,
      'max_discount_value': maxDiscountValue,
      'valid_until': validUntil,
      'description': description,
      'is_saved': isSaved,
      'status': status,
    };
  }
}
