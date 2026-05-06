import 'package:demo_app/core/app_export.dart';

class SettingCardWidget extends StatelessWidget {
  final String title;
  final String statusText;
  final Widget trailing;
  final bool isGreenDot;

  const SettingCardWidget({
    super.key,
    required this.title,
    required this.statusText,
    required this.trailing,
    this.isGreenDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0A1A1C1E),
            blurRadius: 24,
            offset: Offset(0, 8),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppStyles.inter16Bold.copyWith(
                  color: AppColors.color434653,
                  letterSpacing: 0.80,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  if (isGreenDot) ...[
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: AppColors.color3CE36A,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    statusText,
                    style: AppStyles.inter16Bold.copyWith(
                      color: AppColors.color1A1C1E,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing,
        ],
      ),
    );
  }
}

class ProcessingOrdersWidget extends StatelessWidget {
  final String title;
  final String count;
  final List<String> avatars;
  final int additionalCount;

  const ProcessingOrdersWidget({
    super.key,
    required this.title,
    required this.count,
    required this.avatars,
    this.additionalCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: ShapeDecoration(
        color: AppColors.colorF3F3F6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyles.inter16Bold.copyWith(
              color: AppColors.color434653,
              letterSpacing: 1.60,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                count,
                style: AppStyles.inter36ExtraBold.copyWith(
                  color: AppColors.color805600,
                  height: 1.11,
                ),
              ),
              Row(
                children: [
                  for (int i = 0; i < avatars.length; i++)
                    Align(
                      widthFactor: 0.7,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: ShapeDecoration(
                          color: AppColors.colorE2E2E5,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 2, color: AppColors.colorF3F3F6),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(avatars[i]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  if (additionalCount > 0)
                    Align(
                      widthFactor: 0.7,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: ShapeDecoration(
                          color: AppColors.color00357F,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 2, color: AppColors.colorF3F3F6),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '+$additionalCount',
                            style: AppStyles.inter12Regular.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TotalOrdersWidget extends StatelessWidget {
  final String title;
  final String count;
  final String comparisonText;

  const TotalOrdersWidget({
    super.key,
    required this.title,
    required this.count,
    required this.comparisonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: ShapeDecoration(
        color: AppColors.colorF3F3F6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyles.inter16Bold.copyWith(
              color: AppColors.color434653,
              letterSpacing: 1.60,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: AppStyles.inter36ExtraBold.copyWith(
              color: AppColors.color00357F,
              height: 1.11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            comparisonText,
            style: AppStyles.inter12SemiBold.copyWith(
              color: AppColors.color004317,
            ),
          ),
        ],
      ),
    );
  }
}

class RevenueWidget extends StatelessWidget {
  final String title;
  final String amount;
  final String footerText;

  const RevenueWidget({
    super.key,
    required this.title,
    required this.amount,
    required this.footerText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.37, -0.37),
          end: Alignment(0.63, 1.37),
          colors: [AppColors.color00357F, AppColors.color004AAD],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 25,
            offset: Offset(0, 20),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyles.inter16Bold.copyWith(
              color: Colors.white.withOpacity(0.8),
              letterSpacing: 1.60,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: AppStyles.inter36ExtraBold.copyWith(
              color: Colors.white,
              height: 1.11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            footerText,
            style: AppStyles.inter12Regular.copyWith(
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class NewOrderCardWidget extends StatelessWidget {
  final String orderCode;
  final String foodItems;
  final String deliveryAddress;
  final String price;
  final String statusText;
  final Color statusColor;
  final Color statusTextColor;

  const NewOrderCardWidget({
    super.key,
    required this.orderCode,
    required this.foodItems,
    required this.deliveryAddress,
    required this.price,
    required this.statusText,
    required this.statusColor,
    required this.statusTextColor,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: ShapeDecoration(
                  color: AppColors.colorE2E2E5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  image: const DecorationImage(
                    image: NetworkImage("https://placehold.co/64x64"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderCode,
                      style: AppStyles.inter16Bold.copyWith(
                        color: AppColors.color00357F,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      foodItems,
                      style: AppStyles.inter16Bold.copyWith(
                        color: AppColors.color1A1C1E,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      deliveryAddress,
                      style: AppStyles.inter16Regular.copyWith(
                        color: AppColors.color434653,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: AppStyles.inter16SemiBold.copyWith(
                  color: AppColors.color1A1C1E,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: ShapeDecoration(
                  color: statusColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                child: Text(
                  statusText,
                  style: AppStyles.inter12Regular.copyWith(
                    color: statusTextColor,
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
