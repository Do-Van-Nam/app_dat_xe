import 'package:demo_app/core/app_export.dart';

import '../bloc/driver_bloc.dart';
import '../driver_widgets.dart';

class NewRideSection extends StatelessWidget {
  const NewRideSection({super.key});

  String _fmt(int price) => price.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<DriverBloc>().state;
    final offer = state.currentOffer;

    return Stack(
      children: [
        // Map background
        const Positioned.fill(child: MapBackground()),

        // Ride popup
        Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  color: AppColors.colorFFFFFF,
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(blurRadius: 20, color: Color(0x22000000))
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 24),

                    // ── Header: icon + title + distance + countdown ──────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l10n.newRide,
                                    style: AppStyles.inter22Bold),
                                Row(
                                  children: [
                                    Text(
                                      '${l10n.distance} • ',
                                      style: AppStyles.inter12Regular,
                                    ),
                                    Text(
                                      '${offer?.distanceKm.toStringAsFixed(1) ?? "1.2"} KM',
                                      style: AppStyles.inter12SemiBold.copyWith(
                                          color: AppColors.colorF5A623),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Countdown
                          CountdownCircle(
                            seconds: state.countdownSeconds,
                            total: offer?.countdownSeconds ?? 15,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ── Earning card ─────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.colorE8FFF2,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.estimatedEarning,
                                      style: AppStyles.inter11SemiBold.copyWith(
                                          color: AppColors.color27AE60)),
                                  Text(
                                    '${_fmt(offer?.estimatedEarning ?? 29000)}đ',
                                    style: AppStyles.inter36ExtraBold,
                                  ),
                                ],
                              ),
                            ),
                            SvgPicture.asset(
                              AppImages.icMoney,
                              width: 20,
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                  AppColors.color27AE60, BlendMode.srcIn),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ── Route: pickup + dropoff ─────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _AddressRow(
                            iconPath: AppImages.icPickupPin,
                            iconColor: AppColors.color1A56DB,
                            label: l10n.pickupPoint,
                            address: offer?.pickupAddress ?? l10n.pickupAddress,
                          ),
                          const SizedBox(height: 16),
                          _AddressRow(
                            iconPath: AppImages.icDropoffPin,
                            iconColor: AppColors.colorF5A623,
                            label: l10n.dropoffPoint,
                            address:
                                offer?.dropoffAddress ?? l10n.dropoffAddress,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Action buttons ────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      child: Row(
                        children: [
                          // BỎ QUA
                          Expanded(
                            child: GestureDetector(
                              onTap: () => context
                                  .read<DriverBloc>()
                                  .add(const RideRejected()),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  border:
                                      Border.all(color: AppColors.colorE53E3E),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  l10n.reject,
                                  style: AppStyles.inter15SemiBold
                                      .copyWith(color: AppColors.colorE53E3E),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // NHẬN CUỐC
                          Expanded(
                            child: GestureDetector(
                              onTap: () => context
                                  .read<DriverBloc>()
                                  .add(const RideAccepted()),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppColors.color27AE60,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x4C16A34A),
                                      blurRadius: 6,
                                      offset: Offset(0, 4),
                                      spreadRadius: -4,
                                    ),
                                    BoxShadow(
                                      color: Color(0x4C16A34A),
                                      blurRadius: 15,
                                      offset: Offset(0, 10),
                                      spreadRadius: -3,
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  l10n.accept,
                                  style: AppStyles.inter15SemiBold
                                      .copyWith(color: AppColors.colorFFFFFF),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -28,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(999),
                      color: AppColors.color1A56DB,
                      border:
                          Border.all(color: AppColors.colorFFFFFF, width: 4),
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      AppImages.icMotorbike,
                      width: 28,
                      height: 28,
                      colorFilter: const ColorFilter.mode(
                          AppColors.colorFFFFFF, BlendMode.srcIn),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _AddressRow extends StatelessWidget {
  const _AddressRow({
    required this.iconPath,
    required this.iconColor,
    required this.label,
    required this.address,
  });

  final String iconPath;
  final Color iconColor;
  final String label;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          iconPath,
          width: 18,
          height: 18,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppStyles.inter11SemiBold
                    .copyWith(color: AppColors.color1A56DB),
              ),
              Text(address, style: AppStyles.inter15SemiBold),
            ],
          ),
        ),
      ],
    );
  }
}
