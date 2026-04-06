import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/ui/driver/rating/bloc/rate_trip_bloc.dart';

class MapSection extends StatelessWidget {
  const MapSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<RateTripBloc, RateTripState>(
      buildWhen: (p, c) =>
          p.trip.mapDistanceValue != c.trip.mapDistanceValue ||
          p.trip.mapDurationValue != c.trip.mapDurationValue,
      builder: (context, state) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Map image
              Container(
                width: double.infinity,
                height: 220,
                color: AppColors.colorMapBg,
                child: Image.asset(
                  'assets/images/img_map_route.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.expand(),
                ),
              ),

              // Stats bar pinned to bottom
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: AppColors.colorMapStatBg,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    children: [
                      // Distance
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.hoanTatMapDistanceLabel,
                              style: AppStyles.inter11Regular.copyWith(
                                color: AppColors.colorMapStatLabel,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.trip.mapDistanceValue,
                              style: AppStyles.inter18Bold.copyWith(
                                color: AppColors.colorMapStatValue,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Divider
                      Container(
                        width: 1,
                        height: 40,
                        color: AppColors.colorMapStatBorder,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                      ),

                      // Duration
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.hoanTatMapDurationLabel,
                              style: AppStyles.inter11Regular.copyWith(
                                color: AppColors.colorMapStatLabel,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.trip.mapDurationValue,
                              style: AppStyles.inter18Bold.copyWith(
                                color: AppColors.colorMapStatValue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
