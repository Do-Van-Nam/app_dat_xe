import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/data/model/ride/ride.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';

import 'bloc/trip_detail_bloc.dart';
import 'widgets/driver_info_card.dart';
import 'widgets/trip_map_section.dart';
import 'widgets/route_section.dart';
import 'widgets/payment_details.dart';
import 'widgets/rating_section.dart';

class ActivityTripDetailPage extends StatelessWidget {
  const ActivityTripDetailPage({super.key, this.ride});
  final Ride? ride;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => TripDetailBloc()..add(LoadTripDetailEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.tripDetail, style: AppStyles.inter18Bold),
          leading: BackButton(
            onPressed: () async {
              await SharePreferenceUtil.saveCurrentRide(null);
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(PATH_HOME);
              }
            },
          ),
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
                      pickupAddress: ride?.pickupAddress ?? "--",
                      pickupTime: ride?.createdAt?.toString() ?? "--",
                      destinationAddress: ride?.destinationAddress ?? "--",
                      destinationTime: ride?.createdAt?.toString() ?? "--",
                      distance:
                          double.parse(ride?.distance?.toString() ?? "0") /
                              1000,
                      duration: 0,
                      l10n: l10n,
                    ),

                    // 4. Payment Details
                    PaymentDetails(
                      baseFare:
                          double.parse(ride?.basePrice?.toString() ?? "0"),
                      serviceFee:
                          double.parse(ride?.distancePrice?.toString() ?? "0"),
                      discount:
                          double.parse(ride?.discountAmount?.toString() ?? "0"),
                      totalAmount:
                          double.parse(ride?.totalPrice?.toString() ?? "0"),
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
