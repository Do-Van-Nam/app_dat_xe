import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/generated/app_localizations.dart';
import 'package:demo_app/main/data/model/goong/location.dart';
import 'package:demo_app/main/data/model/ride/vehicle.dart';
import 'package:demo_app/main/data/repository/goong_repository.dart';
import 'package:demo_app/main/utils/widget/popup_widgets.dart';
import 'package:demo_app/main/utils/widget/textfield_widgets.dart';
import 'package:demo_app/res/app_colors.dart';
import 'package:demo_app/res/app_images.dart';
import 'package:demo_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demo_app/main/data/model/ride/airport.dart';

import 'airport_booking_bloc.dart';

class AirportBookingPage extends StatefulWidget {
  const AirportBookingPage({super.key});

  @override
  State<AirportBookingPage> createState() => _AirportBookingPageState();
}

class _AirportBookingPageState extends State<AirportBookingPage> {
  final pickUpController = TextEditingController();
  final pickUpFocus = FocusNode();

  @override
  void dispose() {
    pickUpController.dispose();
    pickUpFocus.dispose();
    super.dispose();
  }

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
        body: BlocConsumer<AirportBookingBloc, AirportBookingState>(
          listenWhen: (prev, curr) {
            if (prev is AirportBookingLoaded && curr is AirportBookingLoaded) {
              if (prev.currentLocation != curr.currentLocation) {
                return true;
              }
            }
            if (curr is AirportBookingSuccess) {
              return true;
            }
            return false;
          },
          listener: (context, state) {
            if (state is AirportBookingLoaded && !state.isLoadingLocation) {
              pickUpController.text = state.currentLocation;
            }
            if (state is AirportBookingSuccess) {
              context
                  .push(PATH_WAITING_DRIVER, extra: {'rideId': state.rideId});
            }
          },
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
                                if (state.nearbyAirports.isNotEmpty)
                                  _NearbyAirportsSection(
                                      airports: state.nearbyAirports,
                                      l10n: l10n,
                                      context: context,
                                      selectedAirport: state.selectedAirport),
                                if (state.nearbyAirports.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: AppColors.color_C3C6D5),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<Airport>(
                                          value: state.selectedAirport,
                                          isExpanded: true,
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          hint: Text("Chọn sân bay",
                                              style: AppStyles.inter14Medium),
                                          items: state.nearbyAirports
                                              .map((Airport airport) {
                                            return DropdownMenuItem<Airport>(
                                              value: airport,
                                              child: Text(airport.name ?? '',
                                                  style:
                                                      AppStyles.inter14Medium),
                                            );
                                          }).toList(),
                                          onChanged: (Airport? newValue) {
                                            if (newValue != null) {
                                              context
                                                  .read<AirportBookingBloc>()
                                                  .add(SelectAirportEvent(
                                                      newValue));
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
// ── Trường vị trí hiện tại ──────────────────────────
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16, bottom: 8, left: 16),
                                    child: Text(
                                        state.selectedTripType == 0
                                            ? "Điểm đón khách"
                                            : "Điểm trả khách",
                                        style: AppStyles.inter14Medium),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: AutocompleteTextField<GoongLocation>(
                                    controller: pickUpController,
                                    focusNode: pickUpFocus,
                                    hintText: l10n.yourLocation,
                                    backgroundColor: Colors.white,
                                    fetchSuggestions: (input) async {
                                      final (ok, list) = await GoongRepository()
                                          .getAutocompletePlaces(input: input);
                                      return ok ? list : [];
                                    },
                                    itemBuilder: (context, location) =>
                                        locationSuggestionTile(location),
                                    onSelected: (location) {
                                      pickUpController.text =
                                          location.description;
                                      context.read<AirportBookingBloc>().add(
                                          SavePickupPlaceIdEvent(
                                              location.placeId));
                                    },
                                    // Nút GPS luôn hiển thị (persistentTrailingWidget)
                                    persistentTrailingWidget: GestureDetector(
                                      onTap: state.isLoadingLocation
                                          ? null
                                          : () => context
                                              .read<AirportBookingBloc>()
                                              .add(FetchCurrentLocationEvent()),
                                      child: Tooltip(
                                        message: 'Lấy vị trí hiện tại',
                                        child: state.isLoadingLocation
                                            ? const Padding(
                                                padding: EdgeInsets.all(10),
                                                child: SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              )
                                            : const Icon(
                                                Icons.my_location,
                                                color: Colors.blue,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        // Ngày đi
                                        Expanded(
                                          child: _buildDateTimeField(
                                            context: context,
                                            label: "Ngày đón",
                                            value:
                                                'Hôm nay, ${state.selectedDate.day}/${state.selectedDate.month}',
                                            icon: Icons.calendar_today,
                                            onTap: () async {
                                              final pickedDate =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: state.selectedDate,
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.now().add(
                                                    const Duration(days: 30)),
                                              );
                                              if (pickedDate != null) {
                                                context
                                                    .read<AirportBookingBloc>()
                                                    .add(
                                                        ChangeDate(pickedDate));
                                              }
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        // Giờ đón
                                        Expanded(
                                          child: _buildDateTimeField(
                                            context: context,
                                            label: l10n.pickupTime,
                                            value:
                                                '${state.pickupTime.hour.toString().padLeft(2, '0')}:${state.pickupTime.minute.toString().padLeft(2, '0')}',
                                            icon: Icons.access_time,
                                            onTap: () async {
                                              final pickedTime =
                                                  await showTimePicker(
                                                context: context,
                                                initialTime: state.pickupTime,
                                              );
                                              if (pickedTime != null) {
                                                context
                                                    .read<AirportBookingBloc>()
                                                    .add(ChangePickupTime(
                                                        pickedTime));
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                                      isSelected: vehicle.vehicleType ==
                                          state.selectedVehicleType,
                                      onTap: () => context
                                          .read<AirportBookingBloc>()
                                          .add(SelectVehicleEvent(
                                              vehicle.vehicleType ?? 0)),
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
                        child: commonButton(
                            disable: !(state.selectedTripType != null &&
                                state.selectedVehicleType != null &&
                                state.pickupCoords != null &&
                                state.selectedAirport != null),
                            text: l10n.bookNow,
                            onPressed: () {
                              context
                                  .read<AirportBookingBloc>()
                                  .add(BookAirportRideEvent());
                            }),
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
  final BuildContext context;
  final Airport? selectedAirport;
  const _NearbyAirportsSection(
      {required this.airports,
      required this.l10n,
      required this.context,
      required this.selectedAirport});
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
                  .take(2)
                  .map((airport) => Expanded(
                        child: _airportCard(
                          context,
                          airport,
                          () {
                            context
                                .read<AirportBookingBloc>()
                                .add(SelectAirportEvent(airport));
                          },
                          isSelected: selectedAirport?.id == airport.id,
                        ),
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

Widget _airportCard(BuildContext context, Airport airport, VoidCallback onTap,
    {bool isSelected = false}) {
  return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Text(
              airport.name ?? "--",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.inter16SemiBold.copyWith(
                  color:
                      isSelected ? Colors.white : AppColors.colorTextPrimary),
            ),
            const SizedBox(height: 4),
            Text(airport.code ?? "--",
                style: AppStyles.inter12Regular.copyWith(
                  color: isSelected
                      ? AppColors.color_D9E2FF
                      : AppColors.color_666666,
                )),
          ],
        ),
      ));
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

// Widget t�i s? d?ng cho Ng�y v� Gi?
Widget _buildDateTimeField({
  required BuildContext context,
  required String label,
  required String value,
  required IconData icon,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 95,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: AppColors.color_F3F3F6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.color_666666,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: AppStyles.inter12Regular
                      .copyWith(color: AppColors.color_666666),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: AppStyles.inter14Medium,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
