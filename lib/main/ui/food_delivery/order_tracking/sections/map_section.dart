import 'package:demo_app/core/app_export.dart';

import '../bloc/order_tracking_bloc.dart';
import '../tracking_widgets.dart';

class MapSection extends StatelessWidget {
  const MapSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final driverDistance =
        context.select((OrderTrackingBloc b) => b.state.driverDistance);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 240,
        child: Stack(
          children: [
            // ── Map background (dark teal grid placeholder) ──────────────
            _MapBackground(),

            // ── User / destination marker ────────────────────────────────
            Positioned(
              left: 140,
              top: 80,
              child: SvgPicture.asset(
                AppImages.icMapMarkerUser,
                width: 32,
                height: 32,
                colorFilter: const ColorFilter.mode(
                  AppColors.colorFFFFFF,
                  BlendMode.srcIn,
                ),
              ),
            ),

            // ── Driver marker ────────────────────────────────────────────
            Positioned(
              left: 200,
              top: 120,
              child: SvgPicture.asset(
                AppImages.icMapMarkerDriver,
                width: 28,
                height: 28,
                colorFilter: const ColorFilter.mode(
                  AppColors.colorTeal00E5CC,
                  BlendMode.srcIn,
                ),
              ),
            ),

            // ── Driver info badge (top-left) ─────────────────────────────
            Positioned(
              top: 12,
              left: 12,
              child: _DriverBadge(
                arrivingLabel: l10n.driverArriving,
                distanceLabel:
                    '${l10n.driverDistance.replaceAll('1.2km', driverDistance)}',
              ),
            ),

            // ── FAB buttons (bottom-right) ───────────────────────────────
            Positioned(
              right: 12,
              bottom: 12,
              child: Column(
                children: [
                  MapFabButton(
                    iconPath: AppImages.icLocationTarget,
                    onTap: () => context
                        .read<OrderTrackingBloc>()
                        .add(const RecenterMapTapped()),
                  ),
                  const SizedBox(height: 8),
                  MapFabButton(
                    iconPath: AppImages.icPlus,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Dark map grid background ──────────────────────────────────────────────────
class _MapBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.color0D2137,
            AppColors.color0A1628,
          ],
        ),
      ),
      child: CustomPaint(
        painter: _GridPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.colorTeal00BFA5.withOpacity(0.18)
      ..strokeWidth = 0.7;

    const spacing = 28.0;

    // Perspective-like horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Perspective-like vertical lines with slight angle
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Teal glow paths (simplified)
    final glowPaint = Paint()
      ..color = AppColors.colorTeal00E5CC.withOpacity(0.5)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width * 0.1, size.height * 0.9)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.5,
        size.width * 0.55,
        size.height * 0.45,
      )
      ..quadraticBezierTo(
        size.width * 0.7,
        size.height * 0.42,
        size.width * 0.85,
        size.height * 0.35,
      );
    canvas.drawPath(path, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Driver badge ──────────────────────────────────────────────────────────────
class _DriverBadge extends StatelessWidget {
  const _DriverBadge({
    required this.arrivingLabel,
    required this.distanceLabel,
  });

  final String arrivingLabel;
  final String distanceLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.color0D2137.withOpacity(0.88),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.colorTeal00BFA5.withOpacity(0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppImages.icScooter,
            width: 28,
            height: 28,
            colorFilter: const ColorFilter.mode(
              AppColors.colorTeal00E5CC,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                arrivingLabel,
                style: AppStyles.inter11SemiBold,
              ),
              Text(
                distanceLabel,
                style: AppStyles.inter14SemiBold.copyWith(
                  color: AppColors.colorFFFFFF,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
