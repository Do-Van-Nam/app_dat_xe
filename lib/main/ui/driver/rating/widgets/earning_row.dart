import 'package:demo_app/core/app_export.dart';

/// Single row in the earnings detail card.
class EarningRow extends StatelessWidget {
  const EarningRow({
    super.key,
    required this.label,
    required this.value,
    this.badgeText,
    this.valueColor = AppColors.colorEarningValue,
    this.labelStyle,
    this.valueStyle,
    this.isBold = false,
  });

  final String label;
  final String value;
  final String? badgeText;
  final Color valueColor;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: labelStyle ??
              AppStyles.inter14Regular.copyWith(
                color: AppColors.colorEarningLabel,
              ),
        ),
        if (badgeText != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.colorDiscountBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badgeText!,
              style: AppStyles.inter12SemiBold.copyWith(
                color: AppColors.colorDiscount,
              ),
            ),
          ),
        ],
        const Spacer(),
        Text(
          value,
          style: valueStyle ??
              (isBold
                  ? AppStyles.inter14Bold.copyWith(color: valueColor)
                  : AppStyles.inter14SemiBold.copyWith(color: valueColor)),
        ),
      ],
    );
  }
}
