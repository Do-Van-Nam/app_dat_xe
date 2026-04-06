// ── Driver trip flow states ───────────────────────────────────────────────
enum DriverScreen {
  offline, // Ngoại tuyến – BẬT button
  online, // Trực tuyến – chờ cuốc, TẮT button
  newRide, // Popup cuốc xe mới (15s countdown)
  goingToPickup, // Đang đến điểm đón
  arrivedPickup, // Đã đến điểm đón – chưa bắt đầu
  startTrip, // Đang chạy – bắt đầu chuyến xe
  arrivedDest, // Đã đến điểm trả
}

// ── Bottom nav tabs ───────────────────────────────────────────────────────
enum NavTab { home, orders, activity, profile }

// ── Incoming ride offer ────────────────────────────────────────────────────
class RideOffer {
  const RideOffer({
    required this.distanceKm,
    required this.estimatedEarning,
    required this.pickupAddress,
    required this.dropoffAddress,
    this.countdownSeconds = 15,
  });

  final double distanceKm;
  final int estimatedEarning; // VND
  final String pickupAddress;
  final String dropoffAddress;
  final int countdownSeconds;
}

// ── Customer info ─────────────────────────────────────────────────────────
class CustomerInfo {
  const CustomerInfo({
    required this.name,
    required this.rating,
    required this.paymentMethod,
    required this.pickupAddress,
    this.isVip = false,
    this.avatarAsset,
  });

  final String name;
  final double rating;
  final String paymentMethod;
  final String pickupAddress;
  final bool isVip;
  final String? avatarAsset;
}
