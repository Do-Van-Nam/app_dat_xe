import 'package:demo_app/core/app_export.dart';

/// Row of star icons representing a numeric rating 1–5.
class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.rating,
    this.starSize = 28,
    this.spacing = 4,
  });

  final int rating;
  final double starSize;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final isFilled = i < rating;
        return Padding(
          padding: EdgeInsets.only(right: i < 4 ? spacing : 0),
          child: SvgPicture.asset(
            isFilled ? AppImages.icStarFill : AppImages.icStarEmpty,
            width: starSize,
            height: starSize,
            colorFilter: ColorFilter.mode(
              isFilled ? AppColors.colorStar : AppColors.colorBorder,
              BlendMode.srcIn,
            ),
          ),
        );
      }),
    );
  }
}
