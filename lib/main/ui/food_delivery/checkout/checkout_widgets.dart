import 'package:demo_app/core/app_export.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SectionTitle  –  bold section header e.g. "Tóm tắt đơn hàng"
// ─────────────────────────────────────────────────────────────────────────────
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppStyles.inter16Bold);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AppCard  –  white rounded card wrapper
// ─────────────────────────────────────────────────────────────────────────────
class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.padding});
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
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
// SummaryRow  –  label / value pair row in payment detail
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
// RadioOptionTile  –  single payment method row with radio button
// ─────────────────────────────────────────────────────────────────────────────
class RadioOptionTile<T> extends StatelessWidget {
  const RadioOptionTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.label,
    required this.iconPath,
    required this.onChanged,
  });

  final T value;
  final T groupValue;
  final String label;
  final String iconPath;
  final ValueChanged<T> onChanged;

  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.colorFFFFFF,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _selected ? AppColors.color1A56DB : AppColors.colorBorder,
            width: _selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(
                _selected ? AppColors.color1A56DB : AppColors.color666666,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppStyles.inter15SemiBold.copyWith(
                  color:
                      _selected ? AppColors.color1A56DB : AppColors.color1A1A1A,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _selected
                      ? AppColors.colorRadioActive
                      : AppColors.colorRadioInactive,
                  width: 2,
                ),
              ),
              child: _selected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.colorRadioActive,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PrimaryButton  –  orange CTA
// ─────────────────────────────────────────────────────────────────────────────
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.colorF5A623,
          foregroundColor: AppColors.colorFFFFFF,
          disabledBackgroundColor: AppColors.colorFFC107,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(
                color: AppColors.colorFFFFFF,
                strokeWidth: 2,
              )
            : Text(
                label,
                style: AppStyles.inter16Bold
                    .copyWith(color: AppColors.colorFFFFFF),
              ),
      ),
    );
  }
}
