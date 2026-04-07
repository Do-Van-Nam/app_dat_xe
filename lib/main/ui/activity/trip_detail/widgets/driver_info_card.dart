import 'package:demo_app/core/app_export.dart';

class DriverInfoCard extends StatelessWidget {
  final String driverName;
  final String vehicleInfo;
  final double rating;
  final int totalTrips;
  final AppLocalizations l10n;

  const DriverInfoCard({
    required this.driverName,
    required this.vehicleInfo,
    required this.rating,
    required this.totalTrips,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      color: AppColors.colorFFFFFF,
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: const NetworkImage(
                    "https://randomuser.me/api/portraits/men/32.jpg"),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircleAvatar(
                    backgroundColor: AppColors.rating,
                    child: const Icon(Icons.star,
                        color: AppColors.color_694600, size: 18),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(driverName, style: AppStyles.inter18Bold),
                Text(vehicleInfo, style: AppStyles.inter14Medium),
                Row(
                  children: [
                    const SizedBox(width: 4),
                    Text("$rating (${totalTrips} chuyến)",
                        style: AppStyles.inter14Medium),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 48,
            height: 48,
            child: CircleAvatar(
              backgroundColor: AppColors.colorF9F9FC,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  AppImages.icChat,
                  width: 24,
                  colorFilter: const ColorFilter.mode(
                    AppColors.colorAppBarTitle,
                    BlendMode.srcIn,
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
