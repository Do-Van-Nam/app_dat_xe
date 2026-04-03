import 'package:demo_app/core/app_export.dart';

class BannerSection extends StatelessWidget {
  const BannerSection({super.key});

  // Replace with your actual network or asset image URL.
  static const String _bannerImage = 'assets/images/banner_warehouse.jpg';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset(
              _bannerImage,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.color1E40AF,
              ),
            ),

            // Dark overlay
            Container(color: AppColors.bannerOverlay),

            // Text content
            Positioned(
              left: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.bannerSubtitle,
                    style: AppStyles.inter12SemiBold.copyWith(
                      color: AppColors.colorFFFFFF.withOpacity(0.85),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.bannerTitle,
                    style: AppStyles.inter22Bold,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
