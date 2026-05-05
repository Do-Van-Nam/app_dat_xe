import 'package:demo_app/core/app_export.dart';

class TrackingCodeWidget extends StatelessWidget {
  final String label;
  final String code;
  final String status;

  const TrackingCodeWidget({
    super.key,
    required this.label,
    required this.code,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppStyles.inter10SemiBold.copyWith(
                color: AppColors.color00357F,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              code,
              style: AppStyles.inter24ExtraBold.copyWith(
                color: AppColors.color1A1C1E,
                letterSpacing: -1.20,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: ShapeDecoration(
            color: AppColors.color69FF87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          child: Text(
            status,
            style: AppStyles.inter10SemiBold.copyWith(
              color: AppColors.color002108,
            ),
          ),
        ),
      ],
    );
  }
}

class InfoCardWidget extends StatelessWidget {
  final String label;
  final String value;
  final String icon;

  const InfoCardWidget(
      {super.key,
      required this.label,
      required this.value,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(icon, width: 24, height: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppStyles.inter11SemiBold.copyWith(
              color: AppColors.color737784,
              letterSpacing: 0.55,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppStyles.inter18Bold.copyWith(
              color: AppColors.color1A1C1E,
            ),
          ),
        ],
      ),
    );
  }
}

class ImageProofWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String hint;
  final bool isPhotoTaken;
  final VoidCallback onTap;

  const ImageProofWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.hint,
    required this.isPhotoTaken,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            title,
            style: AppStyles.inter14Bold.copyWith(
              color: AppColors.color1A1C1E,
            ),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 42),
            decoration: ShapeDecoration(
              color: isPhotoTaken
                  ? AppColors.colorB0C6FF.withOpacity(0.3)
                  : AppColors.colorE2E2E5,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 2,
                  color: AppColors.colorC3C6D5_4C,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 15,
                        offset: Offset(0, 10),
                        spreadRadius: -3,
                      )
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      isPhotoTaken ? Icons.check_circle : Icons.camera_alt,
                      color: isPhotoTaken
                          ? AppColors.colorMain
                          : AppColors.color737784,
                      size: 32,
                    ),
                  ),
                ),
                Text(
                  subtitle,
                  style: AppStyles.inter14SemiBold.copyWith(
                    color: AppColors.color434653,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hint,
                  style: AppStyles.inter12Regular.copyWith(
                    color: AppColors.color737784,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ChecklistItemWidget extends StatelessWidget {
  final String title;
  final bool isChecked;
  final VoidCallback onTap;

  const ChecklistItemWidget({
    super.key,
    required this.title,
    required this.isChecked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: ShapeDecoration(
                color: isChecked ? AppColors.colorMain : Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 2,
                    color:
                        isChecked ? AppColors.colorMain : AppColors.colorB0C6FF,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: isChecked
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: AppStyles.inter16SemiBold.copyWith(
                color: AppColors.color1A1C1E,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SenderInfoWidget extends StatelessWidget {
  final String label;
  final String name;
  final String address;

  const SenderInfoWidget({
    super.key,
    required this.label,
    required this.name,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: ShapeDecoration(
              color: AppColors.colorD9E2FF_4C,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Icon(Icons.person, color: AppColors.color1A56DB),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppStyles.inter10SemiBold.copyWith(
                    color: AppColors.color737784,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  name,
                  style: AppStyles.inter16Bold.copyWith(
                    color: AppColors.color1A1C1E,
                  ),
                ),
                Text(
                  address,
                  style: AppStyles.inter12Regular.copyWith(
                    color: AppColors.color434653,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
