import 'package:demo_app/core/app_export.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PlanCard (unselected) — Gói Ngày / Gói Tuần
// ─────────────────────────────────────────────────────────────────────────────
class UnselectedPlanCard extends StatelessWidget {
  const UnselectedPlanCard({
    super.key,
    required this.iconPath,
    required this.name,
    required this.discount,
    required this.benefit,
    required this.price,
    required this.isSelected,
    required this.onTap,
  });

  final String iconPath;
  final String name;
  final String discount;
  final String benefit;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.colorEBF3FF : AppColors.colorF3F3F6,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.color1A56DB : AppColors.colorF3F3F6,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon box
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color:
                    isSelected ? AppColors.colorEBF3FF : AppColors.colorWhite,
                borderRadius: BorderRadius.circular(999),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                iconPath,
                width: 26,
                height: 26,
                colorFilter: ColorFilter.mode(
                  isSelected ? AppColors.color1A56DB : AppColors.color666666,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Name + discount + benefit
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppStyles.inter18Bold),
                  const SizedBox(height: 3),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: ShapeDecoration(
                            color: Colors.white.withValues(alpha: 0.50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          child:
                              Text(discount, style: AppStyles.inter12Regular)),
                      const SizedBox(width: 10),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: ShapeDecoration(
                            color: Colors.white.withValues(alpha: 0.50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          child: Text(benefit, style: AppStyles.inter12Medium)),
                    ],
                  ),
                ],
              ),
            ),

            // Price
            Text(
              price,
              style: AppStyles.inter16Bold.copyWith(
                color: AppColors.colorPriceBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BenefitRow — green check + benefit text (inside month card)
// ─────────────────────────────────────────────────────────────────────────────
class BenefitRow extends StatelessWidget {
  const BenefitRow({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SvgPicture.asset(
            AppImages.icCheckCircle,
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(
              AppColors.color27AE60,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppStyles.inter15SemiBold.copyWith(
                color: AppColors.colorFFFFFF,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PopularBadge — "PHỔ BIẾN NHẤT" orange pill
// ─────────────────────────────────────────────────────────────────────────────
class PopularBadge extends StatelessWidget {
  const PopularBadge({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.rating,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppStyles.inter12SemiBold.copyWith(
          color: AppColors.color_694600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// InfoNoteCard — grey note with info icon and rich text
// ─────────────────────────────────────────────────────────────────────────────
class InfoNoteCard extends StatelessWidget {
  const InfoNoteCard({
    super.key,
    required this.prefix,
    required this.boldPart,
    required this.suffix,
  });

  final String prefix;
  final String boldPart;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.colorInfoBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: SvgPicture.asset(
              AppImages.icInfoCircle,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.color1A56DB,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppStyles.inter13Regular
                    .copyWith(height: 1.5, color: AppColors.color666666),
                children: [
                  TextSpan(text: prefix),
                  TextSpan(
                    text: boldPart,
                    style: AppStyles.inter13SemiBold.copyWith(
                      color: AppColors.color1A56DB,
                    ),
                  ),
                  TextSpan(text: suffix),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RegisterButton — primary CTA
// ─────────────────────────────────────────────────────────────────────────────
class RegisterButton extends StatelessWidget {
  const RegisterButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.colorCtaBg,
          foregroundColor: AppColors.colorCtaText,
          disabledBackgroundColor: AppColors.color1A56DB,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: AppColors.colorFFFFFF,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: AppStyles.inter18Bold.copyWith(
                      color: AppColors.colorCtaText,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    AppImages.icArrowRight,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      AppColors.colorFFFFFF,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
