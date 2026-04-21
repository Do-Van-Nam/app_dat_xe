import 'package:demo_app/core/app_export.dart';

import '../bloc/service_register_bloc.dart';

/// Single service row card with icon, name, sub-label and toggle.
class ServiceToggleCard extends StatelessWidget {
  const ServiceToggleCard({
    super.key,
    required this.item,
    required this.onToggle,
  });

  final ServiceItem item;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final isOrange = item.iconTheme == ServiceIconTheme.orange;

    return CommonCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      margin: EdgeInsets.zero,
      child: Row(
        children: [
          // Icon
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOrange
                  ? AppColors.colorServiceIconBgOrange
                  : AppColors.colorServiceIconBgBlue,
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              item.iconPath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isOrange
                    ? AppColors.colorServiceIconFgOrange
                    : AppColors.colorServiceIconFgBlue,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Name + sub
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: AppStyles.inter15SemiBold),
                const SizedBox(height: 3),
                Text(
                  item.subLabel,
                  style: AppStyles.inter13Regular,
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Toggle
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 50,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: item.isEnabled
                    ? AppColors.colorToggleActive
                    : AppColors.colorToggleInactive,
              ),
              alignment:
                  item.isEnabled ? Alignment.centerRight : Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.colorToggleThumb,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.colorShadowMd,
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
