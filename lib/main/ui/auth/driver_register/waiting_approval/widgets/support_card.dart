import 'package:demo_app/core/app_export.dart';

/// Tappable support card: "Cần trợ giúp? Liên hệ Tổng đài"
class SupportCard extends StatelessWidget {
  const SupportCard({
    super.key,
    required this.question,
    required this.ctaText,
    required this.onTap,
  });

  final String question;
  final String ctaText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.colorSupportCardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.colorSupportCardBorder),
          boxShadow: const [
            BoxShadow(
              color: AppColors.colorShadow,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Headset icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.colorSupportIconBg,
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                AppImages.icHeadset,
                width: 22,
                height: 22,
                colorFilter: const ColorFilter.mode(
                  AppColors.colorSupportIcon,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(question, style: AppStyles.inter13Regular),
                  const SizedBox(height: 3),
                  Text(
                    ctaText,
                    style: AppStyles.inter14SemiBold.copyWith(
                      color: AppColors.colorTextBlue,
                    ),
                  ),
                ],
              ),
            ),

            // Chevron
            SvgPicture.asset(
              AppImages.icArrowRight,
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                AppColors.colorSupportArrow,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
