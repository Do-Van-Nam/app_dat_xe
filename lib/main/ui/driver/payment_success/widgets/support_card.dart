import 'package:demo_app/core/app_export.dart';

/// Tappable support banner with help icon, title, body and chevron.
class SupportCard extends StatelessWidget {
  const SupportCard({
    super.key,
    required this.title,
    required this.body,
    required this.onTap,
  });

  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.colorSupportBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.colorSupportBg),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppImages.icHelpCircle,
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(
                AppColors.colorSupportIcon,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStyles.inter14SemiBold.copyWith(
                      color: AppColors.colorSupportTitle,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(body, style: AppStyles.inter13Regular),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(
              AppImages.icArrowRight,
              width: 16,
              height: 16,
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
