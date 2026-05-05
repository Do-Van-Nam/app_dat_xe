import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/ui/driver/main/sections/shipping/confirm_pickup/confirm_pickup_widgets.dart';

import '../../bloc/driver_bloc.dart';
import '../../driver_widgets.dart';

class StartShippingFoodSection extends StatelessWidget {
  const StartShippingFoodSection({super.key});

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
              // const Positioned.fill(child: MapBackground(dark: true)),

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

              Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: ToggleSection(
                      fixedWidget: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
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
                            borderRadius: 999,
                            onTap: () => context
                                .read<DriverBloc>()
                                .add(const ChatTapped()),
                          ),
                          const SizedBox(width: 8),
                          CircleIconButton(
                            iconPath: AppImages.icPhone,
                            borderRadius: 999,
                            onTap: () => context
                                .read<DriverBloc>()
                                .add(const CallTapped()),
                          ),
                        ],
                      ),
                      contentWidget: Column(
                        children: [
                          const SizedBox(height: 12),

                          // Pickup address
                          IntrinsicHeight(
                            child: Row(
                              spacing: 8,
                              children: [
                                Expanded(
                                  child: CommonCard(
                                    margin: EdgeInsets.zero,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Dia chi",
                                          style: AppStyles.inter11SemiBold
                                              .copyWith(
                                                  color: AppColors.color1A56DB),
                                        ),
                                        Text(
                                          "123 duong abc",
                                          style: AppStyles.inter14Medium,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: CommonCard(
                                    margin: EdgeInsets.zero,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.paymentLabel,
                                          style: AppStyles.inter11SemiBold
                                              .copyWith(
                                                  color: AppColors.color1A56DB),
                                        ),
                                        Text(
                                          "140 000đ ",
                                          style: AppStyles.inter14Medium
                                              .copyWith(
                                                  color: AppColors.colorRed),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 8),
                            decoration: ShapeDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment(0.21, -1.35),
                                end: Alignment(0.79, 2.35),
                                colors: [
                                  AppColors.color7F0002,
                                  AppColors.colorE70003
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                            child: Text(
                              l10n.reportIssue,
                              textAlign: TextAlign.center,
                              style: AppStyles.inter14Bold.copyWith(
                                color: Colors.white,
                                letterSpacing: 1.40,
                              ),
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
                                l10n.completeDelivery,
                                style: AppStyles.inter16Bold
                                    .copyWith(color: AppColors.colorFFFFFF),
                              ),
                            ),
                          ),
                        ],
                      )))
            ],
          ),
        ),

        // ── Bottom sheet ─────────────────────────────────────────────────
      ],
    );
  }
}
