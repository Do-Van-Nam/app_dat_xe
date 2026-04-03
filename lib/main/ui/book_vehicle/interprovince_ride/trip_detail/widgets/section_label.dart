import 'package:demo_app/core/app_export.dart';

/// Uppercase section label (e.g. "CHI TIẾT CHUYẾN ĐI").
class SectionLabel extends StatelessWidget {
  const SectionLabel({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppStyles.inter11SemiBold.copyWith(
        color: AppColors.colorTextSecondary,
        letterSpacing: 0.8,
      ),
    );
  }
}
