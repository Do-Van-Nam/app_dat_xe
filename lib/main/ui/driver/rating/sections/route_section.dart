import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/ui/driver/rating/bloc/rate_trip_bloc.dart';

import '../widgets/route_row.dart';
import '../widgets/section_label.dart';

class RouteSection extends StatelessWidget {
  const RouteSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<RateTripBloc, RateTripState>(
      buildWhen: (p, c) =>
          p.trip.pickupAddress != c.trip.pickupAddress ||
          p.trip.destinationAddress != c.trip.destinationAddress,
      builder: (context, state) {
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
                address: state.trip.pickupAddress,
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
                address: state.trip.destinationAddress,
              ),
            ],
          ),
        );
      },
    );
  }
}
