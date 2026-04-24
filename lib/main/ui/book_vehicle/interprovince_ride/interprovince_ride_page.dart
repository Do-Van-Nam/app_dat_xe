import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/generated/app_localizations.dart';
import 'package:demo_app/main/data/model/ride/vehicle.dart';
import 'package:demo_app/main/utils/widget/app_toast_widget.dart' show AppToast;
import 'package:demo_app/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'interprovince_ride_bloc.dart';
import 'widgets/ride_form_widget.dart';

class InterprovinceRidePage extends StatelessWidget {
  const InterprovinceRidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => InterprovinceRideBloc()..add(LoadInitialData()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.interprovinceRide, style: AppStyles.inter18Bold),
          leading: const BackButton(),
          actions: const [
            Icon(Icons.notifications_outlined),
            SizedBox(width: 16),
          ],
        ),
        backgroundColor: AppColors.background,
        body: BlocConsumer<InterprovinceRideBloc, InterprovinceRideState>(
          listener: (context, state) {
            if (state is InterprovinceRideSuccess) {
              context
                  .push(PATH_WAITING_DRIVER, extra: {'rideId': state.rideId});
            } else if (state is InterprovinceRideError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
            if (state is InterprovinceRideLoaded) {
              if (state.uniqueError != null) {
                AppToast.show(context, state.uniqueError!.message);
              }
            }
          },
          builder: (context, state) {
            final l10n = AppLocalizations.of(context)!;

            if (state is! InterprovinceRideLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            return Stack(
              children: [
                Image.asset(
                  AppImages.imgInterprovince,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const RideFormWidget(),
                              const SizedBox(height: 24),
                              if (state.vehicles.isNotEmpty) ...[
                                Text(
                                  l10n.chooseVehicleType,
                                  style: AppStyles.labelSmall,
                                ),
                                const SizedBox(height: 16),
                                ...state.vehicles.map((vehicle) => _VehicleCard(
                                      vehicle: vehicle,
                                      isSelected: vehicle.vehicleType ==
                                          state.selectedVehicleType,
                                      onTap: () => context
                                          .read<InterprovinceRideBloc>()
                                          .add(SelectVehicleType(
                                              vehicle.vehicleType ?? 1)),
                                    )),
                                const SizedBox(height: 24),
                              ],
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (state.pickupCoords != null &&
                              state.destinationCoords != null &&
                              state.selectedVehicleType != null) {
                            context
                                .read<InterprovinceRideBloc>()
                                .add(BookInterprovinceRideEvent());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: state.pickupCoords != null &&
                                  state.destinationCoords != null &&
                                  state.selectedVehicleType != null
                              ? AppColors.primary
                              : AppColors.color_C3C6D5,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9999)),
                        ),
                        child: Text(l10n.findRideNow,
                            style: AppStyles.buttonLarge),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final bool isSelected;
  final VoidCallback onTap;

  const _VehicleCard({
    required this.vehicle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.color_D9E2FF : AppColors.color_F8F9FA,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: AppColors.primaryBlue, width: 2)
              : Border.all(color: AppColors.color_C3C6D5, width: 2),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                  "https://picsum.photos/id/1071/200/120", // placeholder
                  width: 80,
                  height: 60,
                  fit: BoxFit.cover),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vehicle.name ?? "Xe đưa đón",
                      style: AppStyles.inter16SemiBold),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      SvgPicture.asset(AppImages.icPassenger, width: 12),
                      const SizedBox(width: 4),
                      Text((vehicle.capacity ?? 4).toString(),
                          style: AppStyles.inter12Regular),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (vehicle.description?.isNotEmpty == true)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        vehicle.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.inter12Medium
                            .copyWith(color: Colors.blue),
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${(vehicle.estimatedFare ?? 0).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}đ",
                  style: AppStyles.inter18Bold
                      .copyWith(color: AppColors.primaryBlue),
                ),
                const Text("Gồm phí cầu đường",
                    style: AppStyles.inter10Regular),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
