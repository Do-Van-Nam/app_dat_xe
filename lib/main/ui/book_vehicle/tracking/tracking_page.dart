import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/generated/app_localizations.dart';
import 'package:demo_app/main/data/model/ride/ride.dart';
import 'package:demo_app/main/utils/widget/app_toast_widget.dart';
import 'package:demo_app/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../../driver/map_background.dart';
import 'tracking_bloc.dart';

class TrackingPage extends StatelessWidget {
  final Ride ride;
  const TrackingPage({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => TrackingBloc(ride: ride)..add(LoadTrackingDataEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.deliveryAndPickup),
          leading: BackButton(
            onPressed: () => context.go(PATH_HOME),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {}),
          ],
        ),
        body: BlocConsumer<TrackingBloc, TrackingState>(
          listener: (context, state) {
            if (state is TrackingLoaded) {
              if (state.status == TrackingStatus.driverCompleted) {
                context.go(PATH_ACTIVITY_TRIP_DETAIL, extra: {"ride": ride});
              } else if (state.status == TrackingStatus.driverRejected) {
                AppToast.show(context,
                    "Tài xế đã hủy chuyến, đừng lo chúng tôi sẽ tìm tài xế khác hỗ trợ bạn");
                context.go(PATH_FINDING_DRIVER, extra: {"ride": ride});
              } else if (state.status == TrackingStatus.userCancelSuccess) {
                AppToast.show(context, "Bạn đã hủy chuyến thành công");
                context.go(PATH_HOME);
              } else if (state.status == TrackingStatus.userCancelFailed) {
                AppToast.show(context, "Bạn đã hủy chuyến thất bại");
              } else if (state.status == TrackingStatus.userCancelRequested) {
                AppToast.show(context,
                    "Đã gửi yêu cầu hủy chuyến đến tài xế, chuyến sẽ được hủy khi tài xế đồng ý hủy chuyến");
              }
            }
          },
          builder: (context, state) {
            if (state is TrackingLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TrackingError) {
              return Center(child: Text(state.message));
            }

            if (state is TrackingLoaded) {
              final String title = switch (state.status) {
                TrackingStatus.driverArriving => l10n.driverArriving,
                TrackingStatus.driverArrived => l10n.driverArrived,
                TrackingStatus.driverPickedUp => l10n.driverPickedUp,
                TrackingStatus.driverStarted => l10n.driverStarted,
                TrackingStatus.driverCompleted => l10n.driverCompleted,
                TrackingStatus.driverRejected => l10n.driverRejected,
                TrackingStatus.userCancelRequested => l10n.driverArriving,
                TrackingStatus.userCancelFailed => l10n.driverArriving,
                TrackingStatus.userCancelSuccess => l10n.driverArriving,
              };

              return Stack(
                children: [
                  // Map Background
                  Positioned.fill(
                    child: BlocSelector<TrackingBloc, TrackingState, Ride>(
                        selector: (state) => (state as TrackingLoaded).ride,
                        builder: (context, ride) {
                          return MapBackground(
                            followUserLocation: true,
                            autoFetchRoute: true,
                            originPoint: LatLng(
                              ride.pickupLat?.toDouble() ?? 0,
                              ride.pickupLng?.toDouble() ?? 0,
                            ),
                            destinationPoint: LatLng(
                              ride.destinationLat?.toDouble() ?? 0,
                              ride.destinationLng?.toDouble() ?? 0,
                            ),
                          );
                        }),
                  ),

                  // Driver Arriving Info
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: _DriverArrivingCard(
                      title: title,
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
                        onCancel: () => _showCancelDialog(context, l10n)),
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
  final String title;
  final String arrivalTime;
  final double distance;
  final AppLocalizations l10n;

  const _DriverArrivingCard({
    required this.title,
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
        border: const Border(
            left: BorderSide(color: AppColors.colorMain, width: 4)),
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
                  title,
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
  final double discountedPrice;
  final double originalPrice;
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
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Driver Info
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
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
                  Positioned(
                    bottom: -8,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFF69FF87),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Text("$rating ★",
                          style: const TextStyle(color: Colors.green)),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(driverName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          child: SvgPicture.asset(AppImages.icMessage),
                        ),
                        const SizedBox(width: 12),
                        CircleAvatar(
                          backgroundColor: AppColors.colorMain,
                          child: SvgPicture.asset(AppImages.icPhone),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.color_E8E8EA),
                            child: Text(vehiclePlate)),
                        const SizedBox(width: 8),
                        Text("• $vehicleName",
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Promo & Price
          IntrinsicHeight(
            child: Row(
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
                        Row(
                          children: [
                            SvgPicture.asset(AppImages.icVoucher),
                            const SizedBox(width: 6),
                            const Text("-10%",
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
                                  color: AppColors.colorMain),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "$formattedOriginalđ",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
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

void _showCancelDialog(BuildContext context, AppLocalizations l10n) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Center(
        child: Container(
          padding: const EdgeInsets.all(12),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.colorCancelBg2,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SvgPicture.asset(
            AppImages.icWarning,
            width: 8,
            height: 8,
            colorFilter: const ColorFilter.mode(
              AppColors.colorCancelIcon,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            l10n.titleHuyChuyen,
            style: AppStyles.inter18Bold,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.contentHuyChuyen,
            style: AppStyles.inter14Regular,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<TrackingBloc>().add(CancelRideEvent());
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.colorMain,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                side: const BorderSide(color: AppColors.colorPrimaryDark),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SvgPicture.asset(AppImages.icPhone),
                  // const SizedBox(width: 8),
                  Text(
                    l10n.confirm,
                    style: AppStyles.inter14SemiBold.copyWith(
                      color: AppColors.colorWhite,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                side: BorderSide(color: Colors.grey.shade300, width: 2),
              ),
              child: Text(
                l10n.btnDong,
                style: AppStyles.inter14SemiBold.copyWith(
                  color: AppColors.colorTextSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
