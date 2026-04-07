import 'package:demo_app/core/app_export.dart';

class RouteSection extends StatelessWidget {
  final String pickupAddress;
  final String pickupTime;
  final String destinationAddress;
  final String destinationTime;
  final double distance;
  final int duration;
  final AppLocalizations l10n;

  const RouteSection({
    super.key,
    required this.pickupAddress,
    required this.pickupTime,
    required this.destinationAddress,
    required this.destinationTime,
    required this.distance,
    required this.duration,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "LỘ TRÌNH CHUYẾN ĐI",
            style: AppStyles.inter16SemiBold,
          ),
          const SizedBox(height: 16),

          // Pickup Point
          _RoutePoint(
            icon: AppImages.icDotPickup,
            iconColor: AppColors.primaryBlue,
            time: pickupTime,
            address: pickupAddress,
            isStart: true,
          ),

          // Vertical Line
          Padding(
            padding: const EdgeInsets.only(left: 11),
            child: Container(
              width: 2,
              height: 40,
              color: AppColors.color_F3F3F6,
            ),
          ),

          // Destination Point
          _RoutePoint(
            icon: AppImages.icPinDestination,
            iconColor: Colors.red,
            time: destinationTime,
            address: destinationAddress,
            isStart: false,
          ),

          const SizedBox(height: 24),

          // Distance & Duration
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _InfoColumn(
                label: "QUÃNG ĐƯỜNG",
                value: "${distance} km",
              ),
              Container(height: 40, width: 1, color: AppColors.color_F3F3F6),
              _InfoColumn(
                label: "THỜI GIAN",
                value: "$duration phút",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoutePoint extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final String time;
  final String address;
  final bool isStart;

  const _RoutePoint({
    required this.icon,
    required this.iconColor,
    required this.time,
    required this.address,
    required this.isStart,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(icon, width: 24, color: iconColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isStart ? "Điểm đón • $time" : "Điểm đến • $time",
                style: AppStyles.inter12Regular
                    .copyWith(color: AppColors.color_666666),
              ),
              const SizedBox(height: 4),
              Text(
                address,
                style: AppStyles.inter14Medium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;

  const _InfoColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: AppStyles.inter12Regular
                .copyWith(color: AppColors.color_666666)),
        const SizedBox(height: 4),
        Text(value, style: AppStyles.inter16SemiBold),
      ],
    );
  }
}
