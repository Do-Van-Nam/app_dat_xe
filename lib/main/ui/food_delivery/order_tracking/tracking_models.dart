// ── Order status steps ────────────────────────────────────────────────────
enum OrderStep { preparing, pickedUp, delivering, completed }

// ── Bottom nav tab ────────────────────────────────────────────────────────
enum NavTab { home, activity, profile }

// ── Driver info ───────────────────────────────────────────────────────────
class DriverInfo {
  const DriverInfo({
    required this.name,
    required this.rating,
    required this.totalTrips,
    required this.vehicle,
    required this.plateNumber,
    this.avatarAsset,
  });

  final String name;
  final double rating;
  final int totalTrips;
  final String vehicle;
  final String plateNumber;
  final String? avatarAsset;
}

// ── Order item ────────────────────────────────────────────────────────────
class TrackingOrderItem {
  const TrackingOrderItem({
    required this.qty,
    required this.name,
    required this.variant,
    required this.price,
  });

  final int qty;
  final String name;
  final String variant;
  final int price; // VND
}

// ── Delivery address ──────────────────────────────────────────────────────
class TrackingAddress {
  const TrackingAddress({
    required this.buildingName,
    required this.detail,
  });

  final String buildingName;
  final String detail;
}
