import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/data/model/ride/ride_income_summary.dart';
import 'package:demo_app/main/ui/driver/rating/bloc/rate_trip_bloc.dart';

import '../widgets/app_outlined_card.dart';
import '../widgets/earning_row.dart';
import '../widgets/section_label.dart';

class EarningDetailSection extends StatelessWidget {
  const EarningDetailSection({super.key, required this.trip});
  final RideIncomeSummary trip;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                value: trip.fareDetails?.baseFare?.toString() ?? '0',
                valueColor: AppColors.colorEarningValue,
              ),
              const SizedBox(height: 12),

              // Service fee + discount badge
              EarningRow(
                label: l10n.hoanTatEarningServiceFee,
                value: trip.earnings?.serviceFee?.toString() ?? '0',
                badgeText: "15%",
                valueColor: AppColors.colorTextRed,
              ),
              const SizedBox(height: 14),

              const Divider(height: 1, color: AppColors.colorEarningDivider),
              const SizedBox(height: 14),

              // Total
              EarningRow(
                label: l10n.hoanTatEarningTotalLabel,
                value: trip.earnings?.driverEarnings?.toString() ?? '0',
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
  }
}
