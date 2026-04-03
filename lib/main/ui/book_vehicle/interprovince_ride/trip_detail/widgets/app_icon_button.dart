import 'package:demo_app/core/app_export.dart';

/// Full-width button with optional leading SVG icon.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.label,
    required this.iconPath,
    required this.onTap,
    this.bgColor = AppColors.colorBtnCallBg,
    this.textColor = AppColors.colorBtnCallText,
    this.iconColor = AppColors.colorBtnCallText,
    this.isLoading = false,
    this.height = 52.0,
  });

  final String label;
  final String iconPath;
  final VoidCallback? onTap;
  final Color bgColor;
  final Color textColor;
  final Color iconColor;
  final bool isLoading;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          disabledBackgroundColor: bgColor.withOpacity(0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: textColor,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    iconPath,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: AppStyles.inter16SemiBold.copyWith(color: textColor),
                  ),
                ],
              ),
      ),
    );
  }
}
