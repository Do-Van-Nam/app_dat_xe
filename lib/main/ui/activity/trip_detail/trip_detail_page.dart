import 'package:demo_app/core/app_export.dart';

import 'bloc/trip_detail_bloc.dart';
import 'widgets/driver_info_card.dart';
import 'widgets/trip_map_section.dart';
import 'widgets/route_section.dart';
import 'widgets/payment_details.dart';
import 'widgets/rating_section.dart';

class ActivityTripDetailPage extends StatelessWidget {
  const ActivityTripDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => TripDetailBloc()..add(LoadTripDetailEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.tripDetail, style: AppStyles.inter18Bold),
          leading: const BackButton(),
          actions: const [Icon(Icons.notifications_outlined)],
        ),
        backgroundColor: AppColors.colorF9F9FC,
        body: BlocBuilder<TripDetailBloc, TripDetailState>(
          builder: (context, state) {
            if (state is TripDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TripDetailLoaded) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Map Section
                    TripMapSection(isCompleted: state.isCompleted, l10n: l10n),

                    // 2. Driver Info
                    DriverInfoCard(
                      driverName: state.driverName,
                      vehicleInfo: state.vehicleInfo,
                      rating: state.rating,
                      totalTrips: state.totalTrips,
                      l10n: l10n,
                    ),

                    const SizedBox(height: 16),

                    // 3. Route Section
                    RouteSection(
                      pickupAddress: state.pickupAddress,
                      pickupTime: state.pickupTime,
                      destinationAddress: state.destinationAddress,
                      destinationTime: state.destinationTime,
                      distance: state.distance,
                      duration: state.durationMinutes,
                      l10n: l10n,
                    ),

                    // 4. Payment Details
                    PaymentDetails(
                      baseFare: state.baseFare,
                      serviceFee: state.serviceFee,
                      discount: state.discount,
                      totalAmount: state.totalAmount,
                      l10n: l10n,
                    ),
                    _BottomActions(l10n: l10n),
                    // 5. Rating Section
                    RatingSection(l10n: l10n),

                    const SizedBox(height: 100),
                  ],
                ),
              );
            }

            return const Center(child: Text("Đã xảy ra lỗi"));
          },
        ),
      ),
    );
  }
}

// Bottom Actions
class _BottomActions extends StatelessWidget {
  final AppLocalizations l10n;

  const _BottomActions({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: Text("Đặt lại chuyến này",
                style: AppStyles.inter16SemiBold.copyWith(color: Colors.white)),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.color_E8E8EA,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: Text("Đánh giá tài xế",
                style: AppStyles.inter14Medium
                    .copyWith(color: AppColors.color000000)),
          ),
        ],
      ),
    );
  }
}
