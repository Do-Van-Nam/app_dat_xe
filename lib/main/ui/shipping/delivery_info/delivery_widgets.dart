import 'package:demo_app/core/app_export.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SectionLabel  –  e.g. "● NGƯỜI GỬI"
// ─────────────────────────────────────────────────────────────────────────────
class SectionLabel extends StatelessWidget {
  const SectionLabel({super.key, required this.label, this.iconPath});

  final String label;
  final String? iconPath;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath ?? AppImages.icLocationPin,
          width: 16,
          height: 16,
          colorFilter: const ColorFilter.mode(
            AppColors.color1A56DB,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppStyles.inter12SemiBold.copyWith(
            color: AppColors.color666666,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
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
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.color000000.withOpacity(0.04),
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
// SelectableChip  –  weight / goods-type toggleable chip
// ─────────────────────────────────────────────────────────────────────────────
class SelectableChip extends StatelessWidget {
  const SelectableChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color:
              selected ? AppColors.chipSelectedBg : AppColors.chipUnselectedBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.color1A56DB : AppColors.chipBorder,
          ),
        ),
        child: Text(
          label,
          style: AppStyles.inter13Medium.copyWith(
            color: selected
                ? AppColors.chipSelectedText
                : AppColors.chipUnselectedText,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GoodsTypeChip  –  icon + label chip for goods type
// ─────────────────────────────────────────────────────────────────────────────
class GoodsTypeChip extends StatelessWidget {
  const GoodsTypeChip({
    super.key,
    required this.label,
    required this.iconPath,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String iconPath;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 76,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color:
              selected ? AppColors.chipSelectedBg : AppColors.chipUnselectedBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.color1A56DB : AppColors.chipBorder,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                selected ? AppColors.colorFFFFFF : AppColors.color333333,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppStyles.inter11SemiBold.copyWith(
                color: selected
                    ? AppColors.chipSelectedText
                    : AppColors.chipUnselectedText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AppTextField  –  styled input field
// ─────────────────────────────────────────────────────────────────────────────
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.hint,
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines,
    this.suffix,
  });

  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: minLines,
      style: AppStyles.inter14Regular,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppStyles.inter14Regular.copyWith(
          color: AppColors.colorBDBDBD,
        ),
        filled: true,
        fillColor: AppColors.colorWhite,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: AppColors.color1A56DB, width: 1.5),
        ),
        suffixIcon: suffix,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LabelWithRequired  –  field label with optional red asterisk
// ─────────────────────────────────────────────────────────────────────────────
class LabelWithRequired extends StatelessWidget {
  const LabelWithRequired({
    super.key,
    required this.label,
    this.required = true,
  });

  final String label;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: label,
        style: AppStyles.inter12SemiBold.copyWith(
          color: AppColors.color1A56DB,
          letterSpacing: 0.3,
        ),
        children: required
            ? [
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppColors.colorE53E3E),
                )
              ]
            : null,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PrimaryButton  –  CTA button (orange / amber)
// ─────────────────────────────────────────────────────────────────────────────
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.trailing,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? trailing;

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
            Text(label,
                style: AppStyles.inter16SemiBold
                    .copyWith(color: AppColors.colorFFFFFF)),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
