import 'package:demo_app/core/app_export.dart';

/// Important notice card with info icon, title, and body text.
class NoticeCard extends StatelessWidget {
  const NoticeCard({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.colorNoticeBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.colorNoticeBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: SvgPicture.asset(
              AppImages.icInfoCircle,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.colorNoticeIcon,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyles.inter14SemiBold),
                const SizedBox(height: 6),
                Text(body, style: AppStyles.inter13Regular),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
