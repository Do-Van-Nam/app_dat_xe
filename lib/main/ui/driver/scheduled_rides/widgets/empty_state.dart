import 'package:demo_app/core/app_export.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppImages.icEmptyTrip,
              width: 72,
              height: 72,
              colorFilter: const ColorFilter.mode(
                AppColors.colorEmptyIcon,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppStyles.inter14Regular.copyWith(
                color: AppColors.colorEmptyText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
