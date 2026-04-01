import 'package:demo_app/core/app_export.dart';

class CategoryChip extends StatelessWidget {
  final String title;
  final bool isActive;

  const CategoryChip({super.key, required this.title, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.chipBg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.white : AppColors.textSecondary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
