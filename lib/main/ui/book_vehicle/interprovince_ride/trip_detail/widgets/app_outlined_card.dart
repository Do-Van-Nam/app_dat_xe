import 'package:demo_app/core/app_export.dart';

/// Generic white rounded card with optional border.
class AppOutlinedCard extends StatelessWidget {
  const AppOutlinedCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = AppColors.colorCardBg,
    this.borderColor = AppColors.colorBorder,
    this.borderRadius = 16,
    this.showBorder = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color borderColor;
  final double borderRadius;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        border: showBorder ? Border.all(color: borderColor) : null,
        boxShadow: const [
          BoxShadow(
            color: AppColors.colorShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
