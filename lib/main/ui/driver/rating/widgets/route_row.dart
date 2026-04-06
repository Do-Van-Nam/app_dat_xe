import 'package:demo_app/core/app_export.dart';

/// Address row with coloured dot, sub-label, and address text.
class RouteRow extends StatelessWidget {
  const RouteRow({
    super.key,
    required this.dotColor,
    required this.dotBorderColor,
    required this.subLabel,
    required this.address,
  });

  final Color dotColor;
  final Color dotBorderColor;
  final String subLabel;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: _RouteDot(color: dotColor, borderColor: dotBorderColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subLabel,
                style: AppStyles.inter12Regular.copyWith(
                  color: AppColors.colorTextSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(address, style: AppStyles.inter14SemiBold),
            ],
          ),
        ),
      ],
    );
  }
}

class _RouteDot extends StatelessWidget {
  const _RouteDot({required this.color, required this.borderColor});
  final Color color;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.15),
        border: Border.all(color: borderColor, width: 2),
      ),
      alignment: Alignment.center,
      child: Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
