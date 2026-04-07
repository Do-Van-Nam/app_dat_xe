import 'package:demo_app/core/app_export.dart';

/// Animated green circle with check icon and outer glow ring.
class SuccessHeroIcon extends StatefulWidget {
  const SuccessHeroIcon({super.key, this.circleSize = 88});
  final double circleSize;

  @override
  State<SuccessHeroIcon> createState() => _SuccessHeroIconState();
}

class _SuccessHeroIconState extends State<SuccessHeroIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (_, __) => Stack(
        alignment: Alignment.center,
        children: [
          // Glow ring
          Transform.scale(
            scale: _scale.value,
            child: Container(
              width: widget.circleSize + 28,
              height: widget.circleSize + 28,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.colorGreenGlow,
              ),
            ),
          ),
          // Green circle
          Container(
            width: widget.circleSize,
            height: widget.circleSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.colorGreen,
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppImages.icCheckBold,
              width: widget.circleSize * 0.46,
              height: widget.circleSize * 0.46,
              colorFilter: const ColorFilter.mode(
                AppColors.colorGreenDark,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
