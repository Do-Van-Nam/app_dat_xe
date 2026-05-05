import 'package:demo_app/core/app_export.dart';

class OrderCodeWidget extends StatelessWidget {
  final String label;
  final String code;
  final String status;
  final String restaurantName;

  const OrderCodeWidget({
    super.key,
    required this.label,
    required this.code,
    required this.status,
    required this.restaurantName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        color: AppColors.colorF3F3F6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppStyles.inter11SemiBold.copyWith(
                      color: AppColors.color64748B,
                      letterSpacing: 0.55,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    code,
                    style: AppStyles.inter24ExtraBold.copyWith(
                      color: AppColors.color00357F,
                      letterSpacing: -0.60,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: ShapeDecoration(
                  color: AppColors.color69FF87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: Text(
                  status,
                  style: AppStyles.inter10SemiBold.copyWith(
                    color: AppColors.color00531E,
                    letterSpacing: 0.50,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.storefront,
                  size: 16, color: AppColors.color434653),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  restaurantName,
                  style: AppStyles.inter14SemiBold.copyWith(
                    color: AppColors.color434653,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FoodItemWidget extends StatelessWidget {
  final String title;
  final String details;
  final String price;

  const FoodItemWidget({
    super.key,
    required this.title,
    required this.details,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: AppColors.colorC3C6D5_19,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1,
                  color: AppColors.colorC3C6D5,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.inter16Bold.copyWith(
                    color: AppColors.color1A1C1E,
                  ),
                ),
                if (details.isNotEmpty) ...[
                  Text(
                    details,
                    style: AppStyles.inter12Regular.copyWith(
                      color: AppColors.color434653,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            price,
            style: AppStyles.inter16Bold.copyWith(
              color: AppColors.color00357F,
            ),
          ),
        ],
      ),
    );
  }
}

class ReceiptPhotoWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String requirementHint;
  final String reportIssueText;
  final bool isPhotoTaken;
  final VoidCallback onTap;

  const ReceiptPhotoWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.requirementHint,
    required this.reportIssueText,
    required this.isPhotoTaken,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            title,
            style: AppStyles.inter14Bold.copyWith(
              color: AppColors.color64748B,
              letterSpacing: 1.40,
            ),
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 192,
            decoration: ShapeDecoration(
              color: isPhotoTaken
                  ? AppColors.colorB0C6FF.withOpacity(0.3)
                  : AppColors.colorE2E2E5,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 2,
                  color: AppColors.colorC3C6D5_66,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isPhotoTaken ? Icons.check_circle : Icons.camera_alt,
                  color: isPhotoTaken
                      ? AppColors.colorMain
                      : AppColors.color00357F,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: AppStyles.inter14Bold.copyWith(
                    color: AppColors.color00357F,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            requirementHint,
            textAlign: TextAlign.center,
            style: AppStyles.inter10Regular.copyWith(
              color: AppColors.color434653,
              height: 1.63,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: ShapeDecoration(
              gradient: const LinearGradient(
                begin: Alignment(0.21, -1.35),
                end: Alignment(0.79, 2.35),
                colors: [AppColors.color7F0002, AppColors.colorE70003],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            child: Text(
              reportIssueText,
              textAlign: TextAlign.center,
              style: AppStyles.inter14Bold.copyWith(
                color: Colors.white,
                letterSpacing: 1.40,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NextDeliveryPointWidget extends StatelessWidget {
  final String header;
  final String locationTitle;
  final String locationAddress;
  final String mapLabel;
  final String callLabel;

  const NextDeliveryPointWidget({
    super.key,
    required this.header,
    required this.locationTitle,
    required this.locationAddress,
    required this.mapLabel,
    required this.callLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: ShapeDecoration(
        color: AppColors.colorE8E8EA_7F,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.color805600,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                header,
                style: AppStyles.inter11SemiBold.copyWith(
                  color: AppColors.color434653,
                  letterSpacing: 1.10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locationTitle,
                  style: AppStyles.inter18Bold.copyWith(
                    color: AppColors.color1A1C1E,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  locationAddress,
                  style: AppStyles.inter14Regular.copyWith(
                    color: AppColors.color434653,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.map_outlined,
                          size: 16, color: AppColors.color694600),
                      const SizedBox(width: 8),
                      Text(
                        mapLabel,
                        style: AppStyles.inter12Regular.copyWith(
                          color: AppColors.color694600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.phone,
                          size: 16, color: AppColors.color1A1C1E),
                      const SizedBox(width: 8),
                      Text(
                        callLabel,
                        style: AppStyles.inter12SemiBold.copyWith(
                          color: AppColors.color1A1C1E,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
