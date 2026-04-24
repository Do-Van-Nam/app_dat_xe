import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/ui/book_vehicle/interprovince_ride/interprovince_ride_bloc.dart';
import 'package:demo_app/main/data/model/goong/location.dart';
import 'package:demo_app/main/data/repository/goong_repository.dart';
import 'package:demo_app/main/utils/widget/popup_widgets.dart';
import 'package:demo_app/main/utils/widget/textfield_widgets.dart';

class RideFormWidget extends StatefulWidget {
  const RideFormWidget({super.key});

  @override
  State<RideFormWidget> createState() => _RideFormWidgetState();
}

class _RideFormWidgetState extends State<RideFormWidget> {
  final TextEditingController pickUpController = TextEditingController();
  final FocusNode pickUpFocus = FocusNode();

  final TextEditingController destinationController = TextEditingController();
  final FocusNode destinationFocus = FocusNode();

  @override
  void dispose() {
    pickUpController.dispose();
    pickUpFocus.dispose();
    destinationController.dispose();
    destinationFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<InterprovinceRideBloc, InterprovinceRideState>(
      listener: (context, state) {
        if (state is InterprovinceRideLoaded) {
          if (state.pickupPoint.isNotEmpty &&
              pickUpController.text != state.pickupPoint) {
            pickUpController.text = state.pickupPoint;
          }
          if (state.destination.isNotEmpty &&
              destinationController.text != state.destination) {
            destinationController.text = state.destination;
          }
        }
      },
      builder: (context, state) {
        final bloc = context.read<InterprovinceRideBloc>();

        if (state is! InterprovinceRideLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        return Container(
          margin: EdgeInsets.only(top: 24),
          width: double.infinity,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x141A1C1E),
                blurRadius: 32,
                offset: Offset(0, 8),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Đường kẻ dọc giữa điểm đón và điểm đến
              Positioned(
                left: 29,
                top: 52,
                child: Container(
                  width: 2,
                  height: 77,
                  decoration: const BoxDecoration(
                    color: Color(0x4CC3C6D5),
                  ),
                ),
              ),

              // Nội dung form
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.color_D9E2FF,
                          child: SvgPicture.asset(
                            AppImages.icLocation,
                            width: 24,
                            height: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.interprovinceRide,
                                style: AppStyles.heading1,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.connectAllRoads,
                                style: AppStyles.bodyLarge.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Điểm đón
                    Container(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        l10n.pickupPoint,
                        style: AppStyles.inter14Medium,
                      ),
                    ),
                    AutocompleteTextField<GoongLocation>(
                      controller: pickUpController,
                      focusNode: pickUpFocus,
                      hintText: l10n.yourLocation,
                      backgroundColor: AppColors.color_5F5F,
                      fetchSuggestions: (input) async {
                        final (ok, list) = await GoongRepository()
                            .getAutocompletePlaces(input: input);
                        return ok ? list : [];
                      },
                      itemBuilder: (context, location) =>
                          locationSuggestionTile(location),
                      onSelected: (location) {
                        pickUpController.text = location.description;
                        bloc.add(SavePickupPlaceIdEvent(
                            location.placeId, location.description));
                      },
                      persistentTrailingWidget: InkWell(
                        onTap: () {
                          bloc.add(FetchCurrentLocationEvent());
                        },
                        child: state.isLoadingLocation
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : const Icon(
                                Icons.my_location,
                                color: Colors.blue,
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Điểm đến
                    Container(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        l10n.destination,
                        style: AppStyles.inter14Medium,
                      ),
                    ),
                    AutocompleteTextField<GoongLocation>(
                      controller: destinationController,
                      focusNode: destinationFocus,
                      hintText: l10n.whereToGo,
                      backgroundColor: AppColors.color_5F5F,
                      fetchSuggestions: (input) async {
                        final (ok, list) = await GoongRepository()
                            .getAutocompletePlaces(input: input);
                        return ok ? list : [];
                      },
                      itemBuilder: (context, location) =>
                          locationSuggestionTile(location),
                      onSelected: (location) {
                        destinationController.text = location.description;
                        bloc.add(SaveDestinationPlaceIdEvent(
                            location.placeId, location.description));
                      },
                    ),

                    const SizedBox(height: 24),

                    // Ngày đi & Giờ đón (2 cột)
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          // Ngày đi
                          Expanded(
                            child: _buildDateTimeField(
                              context: context,
                              label: l10n.date,
                              value:
                                  'Hôm nay, ${state.selectedDate.day}/${state.selectedDate.month}',
                              icon: Icons.calendar_today,
                              onTap: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: state.selectedDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 30)),
                                );
                                if (pickedDate != null) {
                                  bloc.add(ChangeDate(pickedDate));
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
                                final pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: state.pickupTime,
                                );
                                if (pickedTime != null) {
                                  bloc.add(ChangePickupTime(pickedTime));
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget tái sử dụng cho Ngày và Giờ
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
          color: AppColors.inputBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.textSecondary,
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
                    style: AppStyles.labelSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.43,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
