import 'package:demo_app/core/app_export.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppCard — white rounded section wrapper
// ─────────────────────────────────────────────────────────────────────────────
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.colorFFFFFF,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// QuantityStepper — [ − N + ] control
// ─────────────────────────────────────────────────────────────────────────────
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.colorStepperBorder),
        borderRadius: BorderRadius.circular(24),
        color: AppColors.colorStepperBg,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            iconPath: AppImages.icMinus,
            onTap: onDecrease,
          ),
          SizedBox(
            width: 32,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: AppStyles.inter16Bold,
            ),
          ),
          _StepButton(
            iconPath: AppImages.icPlus,
            onTap: onIncrease,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.iconPath, required this.onTap});

  final String iconPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 16,
        height: 16,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          iconPath,
          width: 16,
          height: 16,
          colorFilter: const ColorFilter.mode(
            AppColors.color1A56DB,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DeleteRow — 🗑 Xóa button
// ─────────────────────────────────────────────────────────────────────────────
class DeleteRow extends StatelessWidget {
  const DeleteRow({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppImages.icTrash,
            width: 14,
            height: 14,
            colorFilter: const ColorFilter.mode(
              AppColors.colorE53E3E,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style:
                AppStyles.inter13Medium.copyWith(color: AppColors.colorE53E3E),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SummaryRow — e.g. "Tạm tính   170.000đ"
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
// PrimaryButton — orange CTA
// ─────────────────────────────────────────────────────────────────────────────
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.colorF5A623,
          foregroundColor: AppColors.colorFFFFFF,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppStyles.inter16SemiBold
                  .copyWith(color: AppColors.colorFFFFFF),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward,
                size: 20, color: AppColors.colorFFFFFF),
          ],
        ),
      ),
    );
  }
}
