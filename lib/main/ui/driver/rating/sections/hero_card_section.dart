import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/data/model/ride/ride_income_summary.dart';

import '../bloc/rate_trip_bloc.dart';

class HeroCardSection extends StatelessWidget {
  const HeroCardSection({super.key, required this.trip});
  final RideIncomeSummary trip;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            AppColors.colorPrimaryGradientStart,
            AppColors.colorPrimaryGradientEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Green check icon
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.colorHeroCheckBg,
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppImages.icCheckCircleFill,
              width: 28,
              height: 28,
              colorFilter: const ColorFilter.mode(
                AppColors.colorHeroCheckIcon,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Label
          Text(
            l10n.hoanTatHeroLabel,
            style: AppStyles.inter13SemiBold.copyWith(
              color: AppColors.colorHeroLabel,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 8),

          // Amount
          Text(
            trip.earnings?.driverEarnings?.toString() ?? '0',
            style: AppStyles.inter36Bold.copyWith(
              color: AppColors.colorHeroAmount,
            ),
          ),
          const SizedBox(height: 12),

          // Duration • Distance badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.colorHeroBadgeBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  AppImages.icClock,
                  width: 14,
                  height: 14,
                  colorFilter: const ColorFilter.mode(
                    AppColors.colorHeroBadgeText,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${trip.journey?.durationMin} • ${trip.journey?.distanceKm}',
                  style: AppStyles.inter13Medium.copyWith(
                    color: AppColors.colorHeroBadgeText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
