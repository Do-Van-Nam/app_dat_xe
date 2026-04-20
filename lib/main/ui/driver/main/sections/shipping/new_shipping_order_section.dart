import 'package:demo_app/core/app_export.dart';

import '../../bloc/driver_bloc.dart';
import '../../driver_widgets.dart';

class NewShippingOrderSection extends StatelessWidget {
  const NewShippingOrderSection({super.key});

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
        // const Positioned.fill(child: MapBackground()),

        // Ride popup
        Positioned(
          bottom: 24,
          left: 4,
          right: 4,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.colorFFFFFF,
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(blurRadius: 20, color: Color(0x22000000))
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: [
                    // ── Header: icon + title + distance + countdown ──────────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.color_D9E2FF,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(l10n.expressDelivery,
                                    style: AppStyles.inter11SemiBold),
                              ),
                              Text(
                                '${offer?.totalPrice ?? 29000}đ',
                                style: AppStyles.inter36ExtraBold
                                    .copyWith(color: AppColors.color000000),
                              ),
                              Text(l10n.estimatedEarning,
                                  style: AppStyles.inter14Medium.copyWith(
                                      color: AppColors.bannerOverlay)),
                            ],
                          ),
                        ),

                        // Countdown
                        CountdownCircle(
                          seconds: state.countdownSeconds,
                          total: 15,
                          color: AppColors.color_805600,
                        ),
                      ],
                    ),

                    // ── Route: pickup + dropoff ─────────────────────────────
                    grayContainer(
                      child: Column(
                        children: [
                          _AddressRow(
                            iconPath: AppImages.icPickupPin,
                            iconColor: AppColors.color1A56DB,
                            label: l10n.pickupLocation,
                            address: offer?.pickupAddress ?? l10n.pickupAddress,
                          ),
                          const SizedBox(height: 16),
                          _AddressRow(
                            iconPath: AppImages.icDropoffPin,
                            iconColor: AppColors.colorF5A623,
                            label: l10n.dropoffLocation,
                            address: offer?.destinationAddress ??
                                l10n.dropoffAddress,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          context.read<DriverBloc>().add(const RideAccepted()),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.colorF5A623,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.colorF5A623,
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
                    GestureDetector(
                      onTap: () =>
                          context.read<DriverBloc>().add(const RideRejected()),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          // border: Border.all(color: AppColors.colorE53E3E),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          l10n.reject,
                          style: AppStyles.inter15SemiBold
                              .copyWith(color: AppColors.color_C3C6D5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
