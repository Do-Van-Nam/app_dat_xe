import 'dart:math' as math;
import 'package:demo_app/core/app_export.dart';
import 'waiting_driver_bloc.dart';

// ═══════════════════════════════════════════════════════════════
//  PAGE
// ═══════════════════════════════════════════════════════════════

class WaitingDriverPage extends StatelessWidget {
  const WaitingDriverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WaitingDriverBloc(),
      child: const _WaitingDriverView(),
    );
  }
}

class _WaitingDriverView extends StatelessWidget {
  const _WaitingDriverView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<WaitingDriverBloc, WaitingDriverState>(
      listenWhen: (p, c) =>
          p.status != c.status || p.errorMessage != c.errorMessage,
      listener: (context, state) {
        if (state.status == WaitingDriverStatus.error &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
        if (state.status == WaitingDriverStatus.cancelled) {
          Navigator.of(context).pop();
        }
        if (state.status == WaitingDriverStatus.found) {
          // TODO: push to driver-on-the-way screen
          context.push(PATH_TRIP_DETAIL);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _WaitingDriverAppBar(title: l10n.doiChuyenAppBarTitle),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              _SearchingHeroSection(),
              SizedBox(height: 32),
              _ScheduleInfoSection(),
              SizedBox(height: 16),
              _RouteSection(),
              SizedBox(height: 24),
              _CancelButtonSection(),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  APP BAR
// ═══════════════════════════════════════════════════════════════

class _WaitingDriverAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _WaitingDriverAppBar({required this.title});
  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.colorAppBarBg,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 1,
          thickness: 1,
          color: AppColors.colorAppBarDivider,
        ),
      ),
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SvgPicture.asset(
            AppImages.icArrowBack,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              AppColors.colorTextBlue,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      title: Text(
        title,
        style: AppStyles.inter18SemiBold.copyWith(
          color: AppColors.colorAppBarTitle,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => context
              .read<WaitingDriverBloc>()
              .add(const WaitingDriverMoreOptionsTapped()),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SvgPicture.asset(
              AppImages.icMoreDots,
              width: 6,
              height: 6,
              colorFilter: const ColorFilter.mode(
                AppColors.colorTextBlue,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 1 – SEARCHING HERO (animated car icon + text)
// ═══════════════════════════════════════════════════════════════

class _SearchingHeroSection extends StatelessWidget {
  const _SearchingHeroSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        const _PulsingCarIcon(),
        const SizedBox(height: 28),
        Text(
          l10n.doiChuyenSearchingTitle,
          textAlign: TextAlign.center,
          style: AppStyles.inter22Bold,
        ),
        const SizedBox(height: 12),
        Text(
          l10n.doiChuyenSearchingBody,
          textAlign: TextAlign.center,
          style: AppStyles.inter15Regular,
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 2 – SCHEDULE INFO CARD
// ═══════════════════════════════════════════════════════════════

class _ScheduleInfoSection extends StatelessWidget {
  const _ScheduleInfoSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<WaitingDriverBloc, WaitingDriverState>(
      buildWhen: (p, c) => p.scheduleValue != c.scheduleValue,
      builder: (context, state) {
        return _InfoCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Calendar icon box
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.colorCalendarIconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AppImages.icCalendar,
                  width: 22,
                  height: 22,
                  colorFilter: const ColorFilter.mode(
                    AppColors.colorCalendarIcon,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.doiChuyenScheduleLabel,
                      style: AppStyles.inter11Regular.copyWith(
                        color: AppColors.colorTextSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state.scheduleValue,
                      style: AppStyles.inter16Bold,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 3 – ROUTE CARD (pickup + destination)
// ═══════════════════════════════════════════════════════════════

class _RouteSection extends StatelessWidget {
  const _RouteSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<WaitingDriverBloc, WaitingDriverState>(
      buildWhen: (p, c) =>
          p.pickupAddress != c.pickupAddress ||
          p.destinationAddress != c.destinationAddress,
      builder: (context, state) {
        return _InfoCard(
          child: Column(
            children: [
              // Pickup
              _RouteRow(
                label: l10n.doiChuyenPickupLabel,
                address: state.pickupAddress,
                dotWidget: _PickupDot(),
              ),
              // Connector
              // Padding(
              //   padding: const EdgeInsets.only(left: 13),
              //   child: Row(
              //     children: [
              //       Container(
              //         width: 2,
              //         height: 20,
              //         color: AppColors.colorRouteLine,
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 12),
              // Destination
              _RouteRow(
                label: l10n.doiChuyenDestinationLabel,
                address: state.destinationAddress,
                dotWidget: _DestinationDot(),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 4 – CANCEL BUTTON
// ═══════════════════════════════════════════════════════════════

class _CancelButtonSection extends StatelessWidget {
  const _CancelButtonSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<WaitingDriverBloc, WaitingDriverState>(
      buildWhen: (p, c) => p.isCancelLoading != c.isCancelLoading,
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: state.isCancelLoading
                ? null
                : () => _showCancelDialog(context, l10n),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.colorCancelBg,
              disabledBackgroundColor: AppColors.colorCancelBg,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
                side: const BorderSide(
                  color: AppColors.colorCancelBorder,
                ),
              ),
            ),
            child: state.isCancelLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.colorCancelText,
                    ),
                  )
                : Text(
                    l10n.doiChuyenCancelButton,
                    style: AppStyles.inter16Medium.copyWith(
                      color: AppColors.colorCancelText,
                    ),
                  ),
          ),
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.doiChuyenCancelButton, style: AppStyles.inter18Bold),
        content: Text(
          'Bạn có chắc chắn muốn hủy yêu cầu không?',
          style: AppStyles.inter14Regular,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Không',
                style: AppStyles.inter14SemiBold.copyWith(
                  color: AppColors.colorTextSecondary,
                )),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context
                  .read<WaitingDriverBloc>()
                  .add(const WaitingDriverCancelConfirmed());
            },
            child: Text('Có, hủy',
                style: AppStyles.inter14SemiBold.copyWith(
                  color: AppColors.colorPrimary,
                )),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SHARED WIDGETS
// ═══════════════════════════════════════════════════════════════

/// Pulsing animated car icon circle.
class _PulsingCarIcon extends StatefulWidget {
  const _PulsingCarIcon();

  @override
  State<_PulsingCarIcon> createState() => _PulsingCarIconState();
}

class _PulsingCarIconState extends State<_PulsingCarIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 1.0, end: 1.14).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, __) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow ring
            Transform.scale(
              scale: _pulse.value,
              child: Container(
                width: 108,
                height: 108,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.colorCarCircleGlow,
                ),
              ),
            ),
            // Inner circle with car icon
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.colorCarCircleBg,
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                AppImages.icCarWhite,
                width: 44,
                height: 44,
                colorFilter: const ColorFilter.mode(
                  AppColors.colorCarIcon,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Rounded card used for info sections.
class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.color_F3F3F6,
        borderRadius: BorderRadius.circular(16),
        // border: Border.all(color: AppColors.color_E2E2E5),
      ),
      child: child,
    );
  }
}

/// Single address row used in route card.
class _RouteRow extends StatelessWidget {
  const _RouteRow({
    required this.label,
    required this.address,
    required this.dotWidget,
  });

  final String label;
  final String address;
  final Widget dotWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: dotWidget,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppStyles.inter11Regular.copyWith(
                  color: AppColors.colorTextSecondary,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 3),
              Text(address, style: AppStyles.inter14SemiBold),
            ],
          ),
        ),
      ],
    );
  }
}

/// Blue filled circle dot for pickup.
class _PickupDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.colorPrimaryLight,
        border: Border.all(
          color: AppColors.colorDotPickupBorder,
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.colorDotPickup,
        ),
      ),
    );
  }
}

/// Yellow/orange ring dot for destination.
class _DestinationDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.colorYellowLight,
        border: Border.all(
          color: AppColors.colorYellow,
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.colorYellow,
        ),
      ),
    );
  }
}
