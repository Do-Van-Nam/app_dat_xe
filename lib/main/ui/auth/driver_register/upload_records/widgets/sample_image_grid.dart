import 'package:demo_app/core/app_export.dart';

/// Section showing standard sample document photos.
class SampleImageGrid extends StatelessWidget {
  const SampleImageGrid({
    super.key,
    required this.title,
    required this.imagePaths,
  });

  final String title;
  final List<String> imagePaths;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyles.inter11SemiBold.copyWith(
            color: AppColors.colorTextSecondary,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicHeight(
            child: Row(
              children: imagePaths.asMap().entries.map((entry) {
                final i = entry.key;
                final path = entry.value;
                return SizedBox(
                  width: 120,
                  height: 100,
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: i < imagePaths.length - 1 ? 10 : 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        path,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.colorSampleBg,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
