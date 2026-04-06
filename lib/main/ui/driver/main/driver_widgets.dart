import 'dart:math' as math;

import 'package:demo_app/core/app_export.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppCard — white rounded floating card
// ─────────────────────────────────────────────────────────────────────────────
class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.padding, this.color});
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? AppColors.colorFFFFFF,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.color1A1A1A.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SosBadge
// ─────────────────────────────────────────────────────────────────────────────
class SosBadge extends StatelessWidget {
  const SosBadge({super.key, required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.colorSosBg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style:
              AppStyles.inter13SemiBold.copyWith(color: AppColors.colorSosText),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MapBackground — light green city map placeholder
// ─────────────────────────────────────────────────────────────────────────────
class MapBackground extends StatelessWidget {
  const MapBackground({super.key, this.dark = false});
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? [AppColors.color1B3A5C, AppColors.color22527A]
              : [const Color(0xFFD8EDDA), const Color(0xFFE6F2E8)],
        ),
      ),
      child: CustomPaint(
        painter: _MapGridPainter(dark: dark),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  _MapGridPainter({this.dark = false});
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = dark
          ? const Color(0xFF4A90B8).withOpacity(0.25)
          : const Color(0xFFB8D4BA).withOpacity(0.5)
      ..strokeWidth = 0.8;

    const step = 32.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Route line
    final routePaint = Paint()
      ..color = dark ? AppColors.color1A56DB : AppColors.color1A56DB
      ..strokeWidth = dark ? 3.5 : 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.5, size.height * 0.15)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.4,
        size.width * 0.3,
        size.height * 0.6,
      )
      ..quadraticBezierTo(
        size.width * 0.28,
        size.height * 0.75,
        size.width * 0.45,
        size.height * 0.85,
      );
    canvas.drawPath(path, routePaint);

    // Main yellow road (light map only)
    if (!dark) {
      final roadPaint = Paint()
        ..color = const Color(0xFFFFDD44)
        ..strokeWidth = 8
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(size.width * 0.6, 0),
        Offset(size.width * 0.6, size.height),
        roadPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// CountdownCircle — animated countdown ring
// ─────────────────────────────────────────────────────────────────────────────
class CountdownCircle extends StatelessWidget {
  const CountdownCircle({
    super.key,
    required this.seconds,
    required this.total,
  });

  final int seconds;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = seconds / total;
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: _CountdownPainter(progress: progress),
            size: const Size(56, 56),
          ),
          Text(
            '${seconds}s',
            style: AppStyles.inter14SemiBold.copyWith(
              color: AppColors.colorTimerText,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountdownPainter extends CustomPainter {
  _CountdownPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3;

    // Background ring
    canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = AppColors.colorF3F4F6
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4);

    // Progress arc
    final arcPaint = Paint()
      ..color = AppColors.colorTimerStroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CountdownPainter old) =>
      old.progress != progress;
}

// ─────────────────────────────────────────────────────────────────────────────
// CircleIconButton — round action button (chat / call)
// ─────────────────────────────────────────────────────────────────────────────
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.iconPath,
    required this.onTap,
    this.size = 44,
    this.iconColor,
    this.bgColor,
    this.borderRadius,
  });

  final String iconPath;
  final VoidCallback onTap;
  final double size;
  final Color? iconColor;
  final Color? bgColor;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: borderRadius != null ? BoxShape.rectangle : BoxShape.circle,
          borderRadius: borderRadius != null
              ? BorderRadius.circular(borderRadius!)
              : null,
          color: bgColor ?? AppColors.colorF3F4F6,
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          iconPath,
          width: size * 0.45,
          height: size * 0.45,
          colorFilter: ColorFilter.mode(
            iconColor ?? AppColors.color333333,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BottomNavBar
// ─────────────────────────────────────────────────────────────────────────────
class DriverBottomNavBar extends StatelessWidget {
  const DriverBottomNavBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
    required this.items,
  });

  final NavTabItem selectedTab;
  final ValueChanged<NavTabItem> onTabSelected;
  final List<NavTabItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.colorFFFFFF,
        border: Border(top: BorderSide(color: AppColors.colorDivider)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: items.map((item) {
            final active = item == selectedTab;
            return Expanded(
              child: GestureDetector(
                onTap: () => onTabSelected(item),
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: active
                            ? const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6)
                            : EdgeInsets.zero,
                        decoration: active
                            ? BoxDecoration(
                                color: AppColors.colorNavActiveBg,
                                borderRadius: BorderRadius.circular(20),
                              )
                            : null,
                        child: SvgPicture.asset(
                          item.icon,
                          width: 22,
                          height: 22,
                          colorFilter: ColorFilter.mode(
                            active
                                ? AppColors.colorNavActive
                                : AppColors.colorNavInactive,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        style: AppStyles.inter10SemiBold.copyWith(
                          color: active
                              ? AppColors.colorNavActive
                              : AppColors.colorNavInactive,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class NavTabItem {
  const NavTabItem({required this.icon, required this.label});
  final String icon;
  final String label;
}
