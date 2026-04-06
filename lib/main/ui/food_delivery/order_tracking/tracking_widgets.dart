import 'package:demo_app/core/app_export.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppCard — white rounded section card
// ─────────────────────────────────────────────────────────────────────────────
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
  });

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
            color: AppColors.color1A1A1A.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SummaryRow — label / value row
// ─────────────────────────────────────────────────────────────────────────────
class SummaryRow extends StatelessWidget {
  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle ?? AppStyles.inter14Regular),
        Text(value, style: valueStyle ?? AppStyles.inter14Regular),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// OutlinedIconButton — e.g. "Gọi"
// ─────────────────────────────────────────────────────────────────────────────
class OutlinedIconButton extends StatelessWidget {
  const OutlinedIconButton({
    super.key,
    required this.iconPath,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.labelColor,
    this.borderColor,
  });

  final String iconPath;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.colorFFFFFF,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: borderColor ?? AppColors.colorCallBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(
                iconColor ?? AppColors.colorF5A623,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppStyles.inter15SemiBold.copyWith(
                color: labelColor ?? AppColors.colorF5A623,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FilledIconButton — e.g. "Chat"
// ─────────────────────────────────────────────────────────────────────────────
class FilledIconButton extends StatelessWidget {
  const FilledIconButton({
    super.key,
    required this.iconPath,
    required this.label,
    required this.onTap,
    this.bgColor,
    this.fgColor,
  });

  final String iconPath;
  final String label;
  final VoidCallback onTap;
  final Color? bgColor;
  final Color? fgColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor ?? AppColors.color1E3A5F,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(
                fgColor ?? AppColors.colorFFFFFF,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppStyles.inter15SemiBold.copyWith(
                color: fgColor ?? AppColors.colorFFFFFF,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MapFabButton — circular FAB on the map
// ─────────────────────────────────────────────────────────────────────────────
class MapFabButton extends StatelessWidget {
  const MapFabButton({
    super.key,
    required this.iconPath,
    required this.onTap,
  });

  final String iconPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.colorFFFFFF,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.color1A1A1A.withOpacity(0.12),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          iconPath,
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(
            AppColors.color1A56DB,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
