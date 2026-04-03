// ── Order item shown in the summary section ───────────────────────────────
class OrderItem {
  const OrderItem({
    required this.id,
    required this.name,
    required this.variant,
    required this.price,
    required this.quantity,
    this.imageAsset,
  });

  final String id;
  final String name;
  final String variant;   // e.g. "Size L, Phô mai thêm"
  final int price;        // total price (unit × qty) in VND
  final int quantity;
  final String? imageAsset;

  String get displayName => '$name x$quantity';
}

// ── Payment method enum ───────────────────────────────────────────────────
enum PaymentMethod { cashOnDelivery, bankTransfer }

// ── Address ───────────────────────────────────────────────────────────────
class DeliveryAddress {
  const DeliveryAddress({
    required this.recipientName,
    required this.fullAddress,
  });

  final String recipientName;
  final String fullAddress;
}
