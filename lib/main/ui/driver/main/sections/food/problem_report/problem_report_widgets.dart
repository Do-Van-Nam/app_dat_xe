import 'package:demo_app/core/app_export.dart';

class ReasonItemWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final String icon;

  const ReasonItemWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: ShapeDecoration(
          color: isSelected ? AppColors.colorD9E2FF : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              padding: const EdgeInsets.all(12),
              decoration: ShapeDecoration(
                color: AppColors.colorD9E2FF,
                shape: const CircleBorder(),
              ),
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(
                    AppColors.colorMain,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: AppStyles.inter16SemiBold.copyWith(
                  color: AppColors.color1A1C1E,
                  letterSpacing: -0.40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdditionalDetailsWidget extends StatelessWidget {
  final String title;
  final String hintText;
  final ValueChanged<String> onChanged;

  const AdditionalDetailsWidget({
    super.key,
    required this.title,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyles.inter12Regular.copyWith(
            color: AppColors.color737784,
            letterSpacing: 1.20,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: ShapeDecoration(
            color: AppColors.colorE2E2E5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: TextField(
            maxLines: 4,
            onChanged: onChanged,
            style: AppStyles.inter16Regular.copyWith(
              color: AppColors.color1A1C1E,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppStyles.inter16Regular.copyWith(
                color: AppColors.color737784,
              ),
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
