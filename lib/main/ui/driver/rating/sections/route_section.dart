import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/data/model/ride/ride_income_summary.dart';
import 'package:demo_app/main/ui/driver/rating/bloc/rate_trip_bloc.dart';

import '../widgets/route_row.dart';
import '../widgets/section_label.dart';

class RouteSection extends StatelessWidget {
  const RouteSection({super.key, required this.trip});
  final RideIncomeSummary trip;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(label: l10n.hoanTatRouteTitle),
          const SizedBox(height: 12),
          RouteRow(
            dotColor: AppColors.colorDotPickup,
            dotBorderColor: AppColors.colorDotPickup,
            subLabel: l10n.hoanTatPickupLabel,
            address: trip.journey?.pickup ?? '',
          ),
          // Connector line
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
            child: Container(
              width: 2,
              height: 18,
              color: AppColors.colorRouteLine,
            ),
          ),
          RouteRow(
            dotColor: AppColors.colorDotDestination,
            dotBorderColor: AppColors.colorDotDestination,
            subLabel: l10n.hoanTatDestinationLabel,
            address: trip.journey?.destination ?? '',
          ),
        ],
      ),
    );
  }
}
