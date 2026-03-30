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
                    AppImages.icHome,
                    AppLocalizations.of(context)!.home,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    1,
                    AppImages.icLoyalty,
                    AppLocalizations.of(context)!.reward,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    2,
                    AppImages.icEntertainment,
                    AppLocalizations.of(context)!.entertainment,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -30,
            left: MediaQuery.of(context).size.width / 2 - 40,
            child: GestureDetector(
              onTap: () => onTabSelected(2),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.0,
                    colors: [
                      Colors.red.shade700, // đỏ sát icon
                      Colors.red.withOpacity(0.35), // đỏ mờ
                      Colors.transparent,
                    ],
                    stops: const [
                      0.55, // giữ đỏ sát
                      0.75, // lan ~2px
                      1.0,
                    ],
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 5),
                  ),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage(AppImages.imgMetfoneV2),
                  ),
                ),
              ),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: isSelected ? 22 : 0,
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: AppColors.colorMain,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
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
