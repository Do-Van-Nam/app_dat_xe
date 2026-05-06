import 'package:demo_app/core/app_export.dart';

class OrderStatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color bgColor;
  final Color textColor;
  final Color labelColor;
  final Widget? trailing;

  const OrderStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.bgColor,
    required this.textColor,
    required this.labelColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        color: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppStyles.inter10Bold.copyWith(
                  color: labelColor,
                  letterSpacing: 0.50,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppStyles.inter24ExtraBold.copyWith(
                  color: textColor,
                  letterSpacing: -0.60,
                ),
              ),
            ],
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class OrderTabItem extends StatelessWidget {
  final String label;
  final String? count;
  final bool isActive;
  final VoidCallback onTap;

  const OrderTabItem({
    super.key,
    required this.label,
    this.count,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: ShapeDecoration(
          color: isActive ? AppColors.color00357F : AppColors.colorF3F3F6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppStyles.inter14Bold.copyWith(
                color: isActive ? Colors.white : AppColors.color434653,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: ShapeDecoration(
                  color: isActive ? AppColors.colorFDAF0A : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                child: Text(
                  count!,
                  style: AppStyles.inter10Black.copyWith(
                    color: isActive
                        ? AppColors.color694600
                        : AppColors.color434653,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class OrderItemCard extends StatelessWidget {
  final String orderCode;
  final String timeAgo;
  final String items;
  final List<String> avatars;
  final int additionalItemsCount;
  final String totalAmount;
  final String? note;
  final String buttonLabel;
  final bool isSecondaryButton;
  final VoidCallback onButtonPressed;
  final String statusLabel;
  final Color labelBgColor;
  final Color labelTextColor;

  const OrderItemCard({
    super.key,
    required this.orderCode,
    required this.timeAgo,
    required this.items,
    required this.avatars,
    this.additionalItemsCount = 0,
    required this.totalAmount,
    this.note,
    required this.buttonLabel,
    this.isSecondaryButton = false,
    required this.onButtonPressed,
    required this.statusLabel,
    required this.labelBgColor,
    required this.labelTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: ShapeDecoration(
                            color: labelBgColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          child: Text(
                            statusLabel,
                            style: AppStyles.inter10Black.copyWith(
                              color: labelTextColor,
                              letterSpacing: -0.50,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          orderCode,
                          style: AppStyles.inter12Medium.copyWith(
                            color: AppColors.color737784,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 14, color: AppColors.colorBA1A1A),
                        const SizedBox(width: 4),
                        Text(
                          timeAgo,
                          style: AppStyles.inter12Medium.copyWith(
                            color: AppColors.colorBA1A1A,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  items,
                  style: AppStyles.inter18Bold.copyWith(
                    color: AppColors.color1A1C1E,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(
                      height: 32,
                      width: avatars.length * 20.0 + 12,
                      child: Stack(
                        children: [
                          for (int i = 0; i < avatars.length; i++)
                            Positioned(
                              left: i * 20.0,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: ShapeDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(avatars[i]),
                                    fit: BoxFit.fill,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 2, color: Colors.white),
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (additionalItemsCount > 0)
                      Text(
                        l10n.ordersOtherItems(additionalItemsCount),
                        style: AppStyles.inter12Medium.copyWith(
                          color: AppColors.color737784,
                        ),
                      ),
                    if (note != null) ...[
                      const Spacer(),
                      Text(
                        '${l10n.ordersNote}: $note',
                        style: AppStyles.inter12Medium.copyWith(
                          color: AppColors.color737784,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.colorEEEEF0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.ordersTotalAmount,
                      style: AppStyles.inter10Bold.copyWith(
                        color: AppColors.color737784,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      totalAmount,
                      style: AppStyles.inter20Black.copyWith(
                        color: AppColors.color1A1C1E,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: onButtonPressed,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    decoration: ShapeDecoration(
                      color: isSecondaryButton
                          ? Colors.white
                          : AppColors.color00357F,
                      shape: RoundedRectangleBorder(
                        side: isSecondaryButton
                            ? const BorderSide(
                                width: 2, color: Color(0x1900357F))
                            : BorderSide.none,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                    child: Text(
                      buttonLabel,
                      style: AppStyles.inter14Bold.copyWith(
                        color: isSecondaryButton
                            ? AppColors.color00357F
                            : Colors.white,
                      ),
                    ),
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
