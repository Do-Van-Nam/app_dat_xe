import 'package:demo_app/generated/app_localizations.dart';
import 'package:demo_app/res/app_colors.dart';
import 'package:demo_app/res/app_fonts.dart';
import 'package:demo_app/res/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: CustomPaint(painter: BottomNavPainter())),
          Positioned.fill(
            child: Row(
              children: [
                Expanded(
                  child: _buildNavItem(
                    0,
                    0 == currentIndex
                        ? AppImages.icHomeActive
                        : AppImages.icHome,
                    AppLocalizations.of(context)!.home,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    1,
                    1 == currentIndex
                        ? AppImages.icActivityActive
                        : AppImages.icActivity,
                    AppLocalizations.of(context)!.activity,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    2,
                    2 == currentIndex
                        ? AppImages.icProfileActive
                        : AppImages.icProfile,
                    AppLocalizations.of(context)!.profile,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String icon, String label) {
    final bool isSelected = index == currentIndex;

    return GestureDetector(
      onTap: () => onTabSelected(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected ? AppColors.color_D9E2FF : Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              colorFilter: ColorFilter.mode(
                isSelected ? AppColors.colorMain : AppColors.colorMain,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: isSelected
                  ? AppTextFonts.poppinsMedium.copyWith(
                      fontSize: 10,
                      color: AppColors.colorMain,
                    )
                  : AppTextFonts.poppinsRegular.copyWith(
                      fontSize: 10,
                      color: AppColors.colorMain,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final width = size.width;
    final height = size.height;

    const cornerRadius = 20.0;

    const iconSize = 60.0;
    const borderGap = 5.0;
    final cutRadius = iconSize / 2 + borderGap;

    final centerX = width / 2;

    final path = Path();

    path.moveTo(cornerRadius, 0);
    path.quadraticBezierTo(0, 0, 0, cornerRadius);
    path.lineTo(0, height);
    path.lineTo(width, height);
    path.lineTo(width, cornerRadius);
    path.quadraticBezierTo(width, 0, width - cornerRadius, 0);
    path.lineTo(centerX + cutRadius, 0);

    path.lineTo(cornerRadius, 0);
    path.close();

    canvas.drawShadow(path, Colors.black26, 6, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
