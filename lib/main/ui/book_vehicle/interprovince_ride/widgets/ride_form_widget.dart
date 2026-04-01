import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/ui/book_vehicle/interprovince_ride/interprovince_ride_bloc.dart';

class RideFormWidget extends StatelessWidget {
  const RideFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<InterprovinceRideBloc, InterprovinceRideState>(
      builder: (context, state) {
        final bloc = context.read<InterprovinceRideBloc>();

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
                    // Tiêu đề chuyến đi
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
                    _buildLocationField(
                      context: context,
                      label: l10n.pickupPoint,
                      value: state.pickupPoint,
                      icon: AppImages.icLocation3,
                      isPickup: true,
                      onTap: () {
                        // TODO: Mở bottom sheet chọn điểm đón
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Chức năng chọn điểm đón đang phát triển')),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Điểm đến
                    _buildLocationField(
                      context: context,
                      label: l10n.destination,
                      value: state.destination.isEmpty
                          ? l10n.whereToGo
                          : state.destination,
                      icon: AppImages.icLocation,
                      isPickup: false,
                      textColor: state.destination.isEmpty
                          ? AppColors.textSecondary.withOpacity(0.5)
                          : AppColors.textPrimary,
                      onTap: () {
                        // TODO: Mở dialog hoặc bottom sheet chọn tỉnh/thành
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Chức năng chọn điểm đến đang phát triển')),
                        );
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

  // Widget tái sử dụng cho Điểm đón & Điểm đến
  Widget _buildLocationField({
    required BuildContext context,
    required String label,
    required String value,
    required String icon,
    required bool isPickup,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: AppColors.inputBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: SvgPicture.asset(
                icon,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  isPickup ? AppColors.primary : AppColors.textSecondary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppStyles.labelSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: AppStyles.bodyLarge.copyWith(
                      color: textColor ?? AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
        height: 87,
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
