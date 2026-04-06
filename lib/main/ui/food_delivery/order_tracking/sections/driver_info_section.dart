import 'package:demo_app/core/app_export.dart';

import '../bloc/order_tracking_bloc.dart';
import '../tracking_widgets.dart';

class DriverInfoSection extends StatelessWidget {
  const DriverInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final driver = context.select((OrderTrackingBloc b) => b.state.driver);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Driver header: avatar + name + rating ─────────────────────
          Row(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: driver.avatarAsset != null
                        ? Image.asset(
                            driver.avatarAsset!,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _AvatarPlaceholder(),
                          )
                        : _AvatarPlaceholder(),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.color38A169,
                        border: Border.fromBorderSide(
                          BorderSide(color: AppColors.colorFFFFFF, width: 2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(driver.name, style: AppStyles.inter18Bold),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppImages.icStar,
                        width: 14,
                        height: 14,
                        colorFilter: const ColorFilter.mode(
                          AppColors.colorFFB800,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        driver.rating.toStringAsFixed(1),
                        style: AppStyles.inter13Medium.copyWith(
                          color: AppColors.colorFFB800,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${_formatTrips(driver.totalTrips)} ${l10n.driverTrips.replaceAll('(1,240 chuyến)', '').trim()})',
                        style: AppStyles.inter13Regular,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.colorDivider),
          const SizedBox(height: 14),

          // ── Vehicle ───────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.vehicleLabel, style: AppStyles.inter14Regular),
              Text(l10n.vehicleValue, style: AppStyles.inter14SemiBold),
            ],
          ),
          const SizedBox(height: 12),

          // ── Plate number ──────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.plateLabel, style: AppStyles.inter14Regular),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.colorPlateNumberBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  l10n.plateValue,
                  style: AppStyles.inter14SemiBold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Action buttons ────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedIconButton(
                iconPath: AppImages.icPhone,
                label: l10n.callDriver,
                onTap: () => context
                    .read<OrderTrackingBloc>()
                    .add(const CallDriverTapped()),
              ),
              const SizedBox(width: 12),
              FilledIconButton(
                iconPath: AppImages.icChat,
                label: l10n.chatDriver,
                onTap: () => context
                    .read<OrderTrackingBloc>()
                    .add(const ChatDriverTapped()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTrips(int trips) {
    if (trips >= 1000) {
      final k = trips / 1000;
      return '${k.toStringAsFixed(k.truncateToDouble() == k ? 0 : 1)}K';
    }
    return '$trips';
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.colorF3F4F6,
      ),
    );
  }
}
