import 'package:demo_app/core/app_export.dart';

/// A single address row with dot, label, address, and optional sub-text.
class RouteRow extends StatelessWidget {
  const RouteRow({
    super.key,
    required this.dotColor,
    required this.dotBorderColor,
    required this.label,
    required this.address,
    this.subText,
    this.dotSize = 20,
  });

  final Color dotColor;
  final Color dotBorderColor;
  final String label;
  final String address;
  final String? subText;
  final double dotSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: _RouteDot(
            size: dotSize,
            color: dotColor,
            borderColor: dotBorderColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppStyles.inter11Regular.copyWith(
                  color: AppColors.colorTextSecondary,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 3),
              Text(address, style: AppStyles.inter14SemiBold),
              if (subText != null) ...[
                const SizedBox(height: 2),
                Text(subText!, style: AppStyles.inter12Regular),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RouteDot extends StatelessWidget {
  const _RouteDot({
    required this.size,
    required this.color,
    required this.borderColor,
  });

  final double size;
  final Color color;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.15),
        border: Border.all(color: borderColor, width: 2),
      ),
      alignment: Alignment.center,
      child: Container(
        width: size * 0.4,
        height: size * 0.4,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
