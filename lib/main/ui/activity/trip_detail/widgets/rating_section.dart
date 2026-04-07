import 'package:demo_app/core/app_export.dart';

class RatingSection extends StatelessWidget {
  final AppLocalizations l10n;

  const RatingSection({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(Icons.star_border_rounded,
                    size: 40, color: Colors.amber),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Vui lòng gửi đánh sự hài lòng của bạn tới tài xế",
            style:
                AppStyles.inter14Medium.copyWith(color: AppColors.color_666666),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
