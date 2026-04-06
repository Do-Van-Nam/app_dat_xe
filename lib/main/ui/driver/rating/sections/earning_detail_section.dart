import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/ui/driver/rating/bloc/rate_trip_bloc.dart';

import '../widgets/app_outlined_card.dart';
import '../widgets/earning_row.dart';
import '../widgets/section_label.dart';

class EarningDetailSection extends StatelessWidget {
  const EarningDetailSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<RateTripBloc, RateTripState>(
      buildWhen: (p, c) => p.trip.earning != c.trip.earning,
      builder: (context, state) {
        final e = state.trip.earning;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionLabel(label: l10n.hoanTatEarningTitle),
            const SizedBox(height: 12),
            AppOutlinedCard(
              child: Column(
                children: [
                  // Base fare
                  EarningRow(
                    label: l10n.hoanTatEarningBaseFare,
                    value: e.baseFare,
                    valueColor: AppColors.colorEarningValue,
                  ),
                  const SizedBox(height: 12),

                  // Service fee + discount badge
                  EarningRow(
                    label: l10n.hoanTatEarningServiceFee,
                    value: e.serviceFeeValue,
                    badgeText: e.serviceFeeDiscount,
                    valueColor: AppColors.colorTextRed,
                  ),
                  const SizedBox(height: 14),

                  const Divider(
                      height: 1, color: AppColors.colorEarningDivider),
                  const SizedBox(height: 14),

                  // Total
                  EarningRow(
                    label: l10n.hoanTatEarningTotalLabel,
                    value: e.totalEarning,
                    isBold: true,
                    labelStyle: AppStyles.inter16Bold,
                    valueStyle: AppStyles.inter22Bold.copyWith(
                      color: AppColors.colorEarningTotal,
                    ),
                    valueColor: AppColors.colorEarningTotal,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
