import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/ui/book_vehicle/booking/booking_bloc.dart';
import 'package:demo_app/main/ui/driver/main/sections/ride/widgets.dart';

import '../../bloc/driver_bloc.dart';
import '../../driver_widgets.dart';

class GoingToPickupSection extends StatefulWidget {
  const GoingToPickupSection({super.key});

  @override
  State<GoingToPickupSection> createState() => _GoingToPickupSectionState();
}

class _GoingToPickupSectionState extends State<GoingToPickupSection> {
  bool _isExpanded = true;

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
                bottom: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onVerticalDragEnd: (details) {
                    if (details.primaryVelocity != null) {
                      if (details.primaryVelocity! > 0) {
                        setState(() => _isExpanded = false); // Swipe down
                      } else if (details.primaryVelocity! < 0) {
                        setState(() => _isExpanded = true); // Swipe up
                      }
                    }
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.colorFFFFFF,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Drag handle
                        GestureDetector(
                          onTap: () {
                            setState(() => _isExpanded = !_isExpanded);
                          },
                          child: Container(
                            width: double.infinity,
                            color: Colors.transparent,
                            padding: const EdgeInsets.only(bottom: 14),
                            alignment: Alignment.center,
                            child: Container(
                              width: 36,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppColors.colorBDBDBD,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
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
                                  Text(state.callInfo?.calleeName ?? "--",
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

                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          alignment: Alignment.topCenter,
                          child: _isExpanded
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
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
                                                AppColors.color666666,
                                                BlendMode.srcIn),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  l10n.pickupLabel,
                                                  style: AppStyles
                                                      .inter11SemiBold
                                                      .copyWith(
                                                          color: AppColors
                                                              .color1A56DB),
                                                ),
                                                Text(
                                                  state.currentOffer
                                                          ?.pickupAddress ??
                                                      "--",
                                                  style:
                                                      AppStyles.inter14Medium,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 8),

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
                                          borderRadius:
                                              BorderRadius.circular(26),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          l10n.arrivedPickup,
                                          style: AppStyles.inter16Bold.copyWith(
                                              color: AppColors.colorFFFFFF),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // hủy chuyến button
                                    CancelButton(
                                      label: l10n.cancelRide,
                                      onTap: () => confirmCancel(context, l10n),
                                      isLoading: false,
                                    ),
                                  ],
                                )
                              : const SizedBox(width: double.infinity),
                        ),
                      ],
                    ),
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
