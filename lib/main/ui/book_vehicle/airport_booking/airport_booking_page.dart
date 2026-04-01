import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/generated/app_localizations.dart';
import 'package:demo_app/res/app_colors.dart';
import 'package:demo_app/res/app_images.dart';
import 'package:demo_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'airport_booking_bloc.dart';

class AirportBookingPage extends StatelessWidget {
  const AirportBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => AirportBookingBloc()..add(LoadAirportBookingEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.airportBooking, style: AppStyles.inter18Bold),
          leading: const BackButton(),
          actions: const [
            Icon(Icons.notifications_outlined),
            SizedBox(width: 16),
          ],
        ),
        body: BlocBuilder<AirportBookingBloc, AirportBookingState>(
          builder: (context, state) {
            if (state is AirportBookingLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AirportBookingLoaded) {
              return Stack(
                children: [
                  Image.asset(
                    AppImages.imgMap,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Trip Type Tabs
                      _TripTypeTabs(
                        selectedIndex: state.selectedTripType,
                        l10n: l10n,
                      ),

                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                            color: AppColors.color_F9F9FC,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(32),
                                topRight: Radius.circular(32)),
                          ),
                          // padding: const EdgeInsets.all(16),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: 16),
                                _NearbyAirportsSection(
                                  airports: state.nearbyAirports,
                                  l10n: l10n,
                                ),

                                // 3. Vehicle Selection
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 24, 16, 8),
                                    child: Text(
                                      l10n.chooseVehicleType,
                                      textAlign: TextAlign.left,
                                      style: AppStyles.inter16SemiBold,
                                    ),
                                  ),
                                ),

                                ...state.vehicles.map((vehicle) => _VehicleCard(
                                      vehicle: vehicle,
                                      isSelected:
                                          vehicle.id == state.selectedVehicleId,
                                      onTap: () => context
                                          .read<AirportBookingBloc>()
                                          .add(SelectVehicleEvent(vehicle.id)),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // 2. Nearby Airports

                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(16.0),
                        child:
                            commonButton(text: l10n.bookNow, onPressed: () {}),
                      )
                    ],
                  ),
                ],
              );
            }

            return const Center(child: Text("Đã xảy ra lỗi"));
          },
        ),
      ),
    );
  }
}

// ==================== WIDGETS DÙNG CHUNG ====================

class _TripTypeTabs extends StatelessWidget {
  final int selectedIndex;
  final AppLocalizations l10n;

  const _TripTypeTabs({required this.selectedIndex, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.color_F3F3F6,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => context
                  .read<AirportBookingBloc>()
                  .add(SelectTripTypeEvent(0)),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: selectedIndex == 0
                      ? AppColors.primaryBlue
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    l10n.toAirport,
                    style: selectedIndex == 0
                        ? AppStyles.inter14Medium.copyWith(color: Colors.white)
                        : AppStyles.inter14Medium,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => context
                  .read<AirportBookingBloc>()
                  .add(SelectTripTypeEvent(1)),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: selectedIndex == 1
                      ? AppColors.primaryBlue
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    l10n.fromAirport,
                    style: selectedIndex == 1
                        ? AppStyles.inter14Medium.copyWith(color: Colors.white)
                        : AppStyles.inter14Medium,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NearbyAirportsSection extends StatelessWidget {
  final List<Airport> airports;
  final AppLocalizations l10n;

  const _NearbyAirportsSection({required this.airports, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(AppImages.icLocation, width: 20),
              const SizedBox(width: 8),
              Text(l10n.nearbyAirports, style: AppStyles.inter14Medium),
            ],
          ),
          const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              spacing: 4,
              children: airports
                  .map((airport) => Expanded(
                        child: _airportCard(context, airport),
                      ))
                  .toList(),
              // children: const [SizedBox(width: 12)],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _airportCard(BuildContext context, Airport airport,
    {bool isSelected = false}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isSelected ? AppColors.primaryBlue : AppColors.color_F3F3F6,
      borderRadius: BorderRadius.circular(16),
      border: isSelected
          ? Border.all(color: AppColors.primaryBlue, width: 2)
          : Border.all(color: AppColors.color_C3C6D5, width: 2),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(AppImages.icPlane, width: 32),
        const SizedBox(height: 12),
        Text(airport.name, style: AppStyles.inter16SemiBold),
        const SizedBox(height: 4),
        Text(airport.subtitle,
            style: AppStyles.inter12Regular
                .copyWith(color: AppColors.color_666666)),
        if (airport.distance.isNotEmpty)
          Text(airport.distance, style: AppStyles.inter12Regular),
      ],
    ),
  );
}

class _VehicleCard extends StatelessWidget {
  final VehicleOption vehicle;
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
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
              child: Image.network(vehicle.imageUrl,
                  width: 80, height: 60, fit: BoxFit.cover),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vehicle.name, style: AppStyles.inter16SemiBold),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      SvgPicture.asset(AppImages.icPassenger, width: 12),
                      const SizedBox(width: 4),
                      Text(vehicle.passengers, style: AppStyles.inter12Regular),
                      const SizedBox(width: 16),
                      SvgPicture.asset(AppImages.icLuggage, width: 12),
                      const SizedBox(width: 4),
                      Text(vehicle.luggage, style: AppStyles.inter12Regular),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: vehicle.tagColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      vehicle.tag,
                      style: AppStyles.inter12Medium
                          .copyWith(color: vehicle.tagColor),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${vehicle.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}đ",
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
