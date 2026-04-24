import 'package:demo_app/core/app_export.dart';

import '../../bloc/driver_bloc.dart';
import '../../driver_models.dart';
import '../../driver_widgets.dart';

/// Shared section for both [DriverScreen.arrivedPickup] → start trip
/// and [DriverScreen.startTrip] → arrived destination.
class StartTripSection extends StatelessWidget {
  const StartTripSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<DriverBloc>().state;
    final isTrip = state.screen == DriverScreen.startTrip ||
        state.screen == DriverScreen.arrivedDest;

    // CTA config
    final ctaLabel = state.screen == DriverScreen.arrivedPickup
        ? l10n.startRideBtn
        : state.screen == DriverScreen.startTrip
            ? l10n.arrivedDestBtn
            : l10n.arrivedDestBtn;

    final ctaColor = state.screen == DriverScreen.arrivedPickup
        ? AppColors.color163172
        : AppColors.colorC0392B;

    final titleText = state.screen == DriverScreen.arrivedPickup
        ? l10n.startTrip
        : state.screen == DriverScreen.startTrip
            ? l10n.arrivedDest
            : l10n.arrivedDest;

    return Column(
      children: [
        // ── Map ─────────────────────────────────────────────────────────
        Expanded(
          child: Stack(
            children: [
              // const Positioned.fill(child: MapBackground()),

              // Navigation card
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: AppCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.toDestination,
                                style: AppStyles.inter11SemiBold),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  state.screen == DriverScreen.arrivedPickup ||
                                          state.screen ==
                                              DriverScreen.arrivedDest
                                      ? '0'
                                      : '${state.tripMinutes}',
                                  style: AppStyles.inter28ExtraBold
                                      .copyWith(color: AppColors.color1A56DB),
                                ),
                                const SizedBox(width: 4),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(l10n.minutesLabel,
                                      style: AppStyles.inter16Medium.copyWith(
                                          color: AppColors.color1A56DB)),
                                ),
                              ],
                            ),
                            Text(
                              '${state.tripKm} ${l10n.kmLabel} • ${state.tripEta}',
                              style: AppStyles.inter13Regular,
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                          width: 24, color: AppColors.colorDivider),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.routeLabel,
                              style: AppStyles.inter11SemiBold),
                          Row(
                            children: [
                              Text(l10n.routeStreet,
                                  style: AppStyles.inter15SemiBold),
                              const SizedBox(width: 6),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: AppColors.colorF3F4F6,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  AppImages.icTurnRight,
                                  width: 14,
                                  height: 14,
                                  colorFilter: const ColorFilter.mode(
                                      AppColors.color333333, BlendMode.srcIn),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Customer on-map overlay
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: CommonCard(
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _CustomerMapCard(state: state, l10n: l10n),
                      // Destination info
                      AppCard(
                        padding: const EdgeInsets.all(14),
                        // decoration: BoxDecoration(
                        //   color: AppColors.colorF5F7FA,
                        //   borderRadius: BorderRadius.circular(12),
                        // ),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.color1A56DB,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.destinationLabel,
                                      style: AppStyles.inter11SemiBold.copyWith(
                                          color: AppColors.color1A56DB)),
                                  Text(
                                      state.currentOffer?.destinationAddress ??
                                          "--",
                                      style: AppStyles.inter16Bold),
                                  // Text(state.currentOffer?.destinationDetail ?? "--",
                                  //     style: AppStyles.inter12Regular),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // CTA button
                      GestureDetector(
                        onTap: () {
                          if (state.screen == DriverScreen.arrivedPickup) {
                            context.read<DriverBloc>().add(const TripStarted());
                          } else {
                            context
                                .read<DriverBloc>()
                                .add(const ArrivedAtDestination());
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            color: ctaColor,
                            borderRadius: BorderRadius.circular(26),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                ctaLabel,
                                style: AppStyles.inter16Bold
                                    .copyWith(color: AppColors.colorFFFFFF),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward,
                                  color: AppColors.colorFFFFFF, size: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CustomerMapCard extends StatelessWidget {
  const _CustomerMapCard({required this.state, required this.l10n});
  final dynamic state;
  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.asset(
              state.activeCustomer.avatarAsset ?? 'assets/images/avatar.jpg',
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.colorF3F4F6),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(state.callInfo?.calleeName ?? "--",
                  style: AppStyles.inter15SemiBold),
              Row(
                children: [
                  SvgPicture.asset(
                    AppImages.icStar,
                    width: 12,
                    height: 12,
                    colorFilter: const ColorFilter.mode(
                        AppColors.colorFFB800, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    state.activeCustomer.rating.toStringAsFixed(1),
                    style: AppStyles.inter12Medium
                        .copyWith(color: AppColors.colorFFB800),
                  ),
                  const SizedBox(width: 6),
                  if (state.activeCustomer.isVip)
                    Text(liveL10n(context), style: AppStyles.inter12Regular),
                ],
              ),
            ],
          ),
          const SizedBox(width: 16),
          CircleIconButton(
            iconPath: AppImages.icChat,
            iconColor: AppColors.colorMain,
            onTap: () => context.read<DriverBloc>().add(const ChatTapped()),
          ),
          const SizedBox(width: 6),
          CircleIconButton(
            iconPath: AppImages.icPhone,
            iconColor: AppColors.colorMain,
            onTap: () => context.read<DriverBloc>().add(const CallTapped()),
          ),
        ],
      ),
    );
  }

  String liveL10n(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return l10n.customerVip;
  }
}
