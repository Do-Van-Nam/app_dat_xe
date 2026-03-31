import 'package:demo_app/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'tracking_bloc.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => TrackingBloc()..add(LoadTrackingDataEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.deliveryAndPickup),
          leading: const BackButton(),
          actions: [
            IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {}),
          ],
        ),
        body: BlocBuilder<TrackingBloc, TrackingState>(
          builder: (context, state) {
            if (state is TrackingLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TrackingError) {
              return Center(child: Text(state.message));
            }

            if (state is TrackingLoaded) {
              return Stack(
                children: [
                  // Map Background
                  Positioned.fill(
                    child: Image.network(
                      "https://picsum.photos/id/1015/800/1200",
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Route Polyline Overlay (giả lập)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: RoutePainter(),
                    ),
                  ),

                  // Driver Arriving Info
                  Positioned(
                    top: 80,
                    left: 16,
                    right: 16,
                    child: _DriverArrivingCard(
                      arrivalTime: state.arrivalTime,
                      distance: state.distance,
                      l10n: l10n,
                    ),
                  ),

                  // Driver Info Bottom Sheet
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _DriverInfoBottomSheet(
                      driverName: state.driverName,
                      vehiclePlate: state.vehiclePlate,
                      vehicleName: state.vehicleName,
                      rating: state.rating,
                      discountedPrice: state.discountedPrice,
                      originalPrice: state.originalPrice,
                      l10n: l10n,
                      onCancel: () =>
                          context.read<TrackingBloc>().add(CancelRideEvent()),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

// ==================== WIDGETS DÙNG CHUNG ====================

class _DriverArrivingCard extends StatelessWidget {
  final String arrivalTime;
  final double distance;
  final AppLocalizations l10n;

  const _DriverArrivingCard({
    required this.arrivalTime,
    required this.distance,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue[100],
            child: const Icon(Icons.pedal_bike, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.driverArriving,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "$arrivalTime • ${distance} KM",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DriverInfoBottomSheet extends StatelessWidget {
  final String driverName;
  final String vehiclePlate;
  final String vehicleName;
  final double rating;
  final int discountedPrice;
  final int originalPrice;
  final AppLocalizations l10n;
  final VoidCallback onCancel;

  const _DriverInfoBottomSheet({
    required this.driverName,
    required this.vehiclePlate,
    required this.vehicleName,
    required this.rating,
    required this.discountedPrice,
    required this.originalPrice,
    required this.l10n,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDiscount = discountedPrice.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
    final formattedOriginal = originalPrice.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Driver Info
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  "https://randomuser.me/api/portraits/men/32.jpg",
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(driverName,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text("$rating ★",
                              style: const TextStyle(color: Colors.green)),
                        ),
                        const SizedBox(width: 12),
                        Text(vehiclePlate),
                        const SizedBox(width: 8),
                        Text("• $vehicleName",
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: const Icon(Icons.chat_bubble_outline),
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.phone, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Promo & Price
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.promoCode,
                          style: const TextStyle(fontSize: 12)),
                      const Row(
                        children: [
                          Icon(Icons.local_offer,
                              color: Colors.orange, size: 20),
                          SizedBox(width: 6),
                          Text("-10%",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.fare, style: const TextStyle(fontSize: 12)),
                      Row(
                        children: [
                          Text(
                            "$formattedDiscountđ",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.blue),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "$formattedOriginalđ",
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Cancel Button
          GestureDetector(
            onTap: onCancel,
            child: Text(
              l10n.cancelRide,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Giả lập đường đi trên bản đồ
class RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width * 0.3, size.height * 0.4);
    path.quadraticBezierTo(
      size.width * 0.45,
      size.height * 0.55,
      size.width * 0.5,
      size.height * 0.7,
    );
    path.quadraticBezierTo(
      size.width * 0.55,
      size.height * 0.85,
      size.width * 0.65,
      size.height * 0.9,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
