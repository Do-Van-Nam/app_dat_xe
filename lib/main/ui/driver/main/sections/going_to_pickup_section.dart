import 'package:demo_app/core/app_export.dart';

import '../bloc/driver_bloc.dart';
import '../driver_widgets.dart';

class GoingToPickupSection extends StatelessWidget {
  const GoingToPickupSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<DriverBloc>().state;

    return Column(
      children: [
        // ── Map area ─────────────────────────────────────────────────────
        Expanded(
          child: Stack(
            children: [
              const Positioned.fill(child: MapBackground(dark: true)),

              // Distance / ETA card
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: AppCard(
                  color: AppColors.colorWhite,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.distanceLabel,
                              style: AppStyles.inter11SemiBold
                                  .copyWith(color: AppColors.colorBDBDBD),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${state.distanceToPickupM}',
                                  style: AppStyles.inter28ExtraBold
                                      .copyWith(color: AppColors.colorMain),
                                ),
                                const SizedBox(width: 4),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    'm',
                                    style: AppStyles.inter18SemiBold
                                        .copyWith(color: AppColors.colorMain),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                          width: 1,
                          height: 40,
                          color: AppColors.colorBDBDBD.withOpacity(0.3)),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                l10n.estimatedLabel,
                                style: AppStyles.inter11SemiBold
                                    .copyWith(color: AppColors.colorBDBDBD),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${state.estimatedMinutes}',
                                    style: AppStyles.inter28ExtraBold
                                        .copyWith(color: AppColors.colorFFB800),
                                  ),
                                  const SizedBox(width: 4),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Text(
                                      l10n.estimatedUnit,
                                      style: AppStyles.inter16Medium.copyWith(
                                          color: AppColors.colorFFB800),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // "Bạn đang ở đây" marker
              Positioned(
                bottom: 280,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.colorFFFFFF,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(blurRadius: 6, color: Color(0x22000000))
                        ],
                      ),
                      child: Text(
                        l10n.youAreHere,
                        style: AppStyles.inter13SemiBold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.color1A56DB,
                        border:
                            Border.all(color: AppColors.colorFFFFFF, width: 3),
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        AppImages.icNavigate,
                        width: 18,
                        height: 18,
                        colorFilter: const ColorFilter.mode(
                            AppColors.colorFFFFFF, BlendMode.srcIn),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.colorFFFFFF,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Drag handle
                      Container(
                        width: 36,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: AppColors.colorBDBDBD,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      // Customer info row
                      Row(
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  state.customer.avatarAsset ??
                                      'assets/images/avatar.jpg',
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 56,
                                    height: 56,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.colorF3F4F6),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.color2ECC71,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        AppImages.icStar,
                                        width: 10,
                                        height: 10,
                                        colorFilter: const ColorFilter.mode(
                                            AppColors.colorFFFFFF,
                                            BlendMode.srcIn),
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        state.customer.rating
                                            .toStringAsFixed(1),
                                        style: AppStyles.inter10SemiBold
                                            .copyWith(
                                                color: AppColors.colorFFFFFF),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(state.customer.name,
                                    style: AppStyles.inter18Bold),
                                Text(
                                  state.customer.paymentMethod,
                                  style: AppStyles.inter13Regular,
                                ),
                              ],
                            ),
                          ),
                          CircleIconButton(
                            iconPath: AppImages.icChat,
                            borderRadius: 16,
                            onTap: () => context
                                .read<DriverBloc>()
                                .add(const ChatTapped()),
                          ),
                          const SizedBox(width: 8),
                          CircleIconButton(
                            iconPath: AppImages.icPhone,
                            borderRadius: 16,
                            onTap: () => context
                                .read<DriverBloc>()
                                .add(const CallTapped()),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Pickup address
                      CommonCard(
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AppImages.icLocationPin,
                              width: 20,
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                  AppColors.color666666, BlendMode.srcIn),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.pickupLabel,
                                    style: AppStyles.inter11SemiBold
                                        .copyWith(color: AppColors.color1A56DB),
                                  ),
                                  Text(
                                    state.customer.pickupAddress,
                                    style: AppStyles.inter14Medium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ĐÃ ĐẾN ĐIỂM ĐÓN button
                      GestureDetector(
                        onTap: () => context
                            .read<DriverBloc>()
                            .add(const ArrivedAtPickup()),
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.colorMain,
                            borderRadius: BorderRadius.circular(26),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            l10n.arrivedPickup,
                            style: AppStyles.inter16Bold
                                .copyWith(color: AppColors.colorFFFFFF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),

        // ── Bottom sheet ─────────────────────────────────────────────────
      ],
    );
  }
}
