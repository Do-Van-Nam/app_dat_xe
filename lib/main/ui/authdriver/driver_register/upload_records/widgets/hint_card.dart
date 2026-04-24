import 'package:demo_app/core/app_export.dart';

/// Info hint card with an icon and descriptive text.
class HintCard extends StatelessWidget {
  const HintCard({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.all(0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            AppImages.icInfoCircle,
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(
              AppColors.colorHintIcon,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: AppStyles.inter13Regular),
          ),
        ],
      ),
    );
  }
}
