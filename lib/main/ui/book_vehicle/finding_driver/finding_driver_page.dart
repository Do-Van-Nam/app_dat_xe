import 'package:demo_app/core/app_export.dart';
import 'finding_driver_bloc.dart';

// ═══════════════════════════════════════════════════════════════
//  PAGE
// ═══════════════════════════════════════════════════════════════

class FindingDriverPage extends StatelessWidget {
  const FindingDriverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FindingDriverBloc()..add(const FindingDriverStartSearch()),
      child: const _FindingDriverView(),
    );
  }
}

class _FindingDriverView extends StatelessWidget {
  const _FindingDriverView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<FindingDriverBloc, FindingDriverState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == FindingDriverStatus.found) {
          // TODO: navigate to tracking page
        }
        if (state.status == FindingDriverStatus.cancelled) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.colorWhite,
        appBar: _FindingDriverAppBar(title: l10n.findingDriverTitle),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _BodyContent(),
              const _CancelButtonSection(),
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

class _FindingDriverAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _FindingDriverAppBar({required this.title});
  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.colorWhite,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SvgPicture.asset(
            AppImages.icArrowBack,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              AppColors.colorTextPrimary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      title: Text(
        title,
        style: AppStyles.inter18SemiBold.copyWith(
          color: AppColors.colorMain,
        ),
      ),
      centerTitle: false,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  BODY CONTENT
// ═══════════════════════════════════════════════════════════════

class _BodyContent extends StatelessWidget {
  const _BodyContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          _MapSection(),
          SizedBox(height: 24),
          _StatusTextSection(),
          SizedBox(height: 20),
          _RouteInfoSection(),
          SizedBox(height: 16),
          _EstimateCardsSection(),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 1 – MAP PREVIEW
// ═══════════════════════════════════════════════════════════════

class _MapSection extends StatelessWidget {
  const _MapSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 280,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.color_F3F3F6,
      ),
      child: Stack(
        children: [
          // Map background
          Positioned.fill(
            child: Image.asset(
              AppImages.imgMap,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.color_F3F3F6,
              ),
            ),
          ),

          // User location pin (center)
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.colorMain,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.colorWhite, width: 3),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.colorShadowMd,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_pin_circle,
                  color: AppColors.colorWhite,
                  size: 28,
                ),
              ),
            ),
          ),

          // Driver car icons
          Positioned(
            top: 40,
            left: 40,
            child: _DriverCarIcon(),
          ),
          Positioned(
            top: 70,
            right: 60,
            child: _DriverCarIcon(),
          ),
          Positioned(
            bottom: 80,
            right: 50,
            child: _DriverCarIcon(),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 2 – STATUS TEXT
// ═══════════════════════════════════════════════════════════════

class _StatusTextSection extends StatelessWidget {
  const _StatusTextSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<FindingDriverBloc, FindingDriverState>(
      buildWhen: (p, c) => p.status != c.status,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              if (state.status == FindingDriverStatus.searching) ...[
                const _PulsingDot(),
                const SizedBox(height: 12),
              ],
              Text(
                l10n.findingDriverConnecting,
                style: AppStyles.inter18Bold.copyWith(
                  color: AppColors.color_1C1E,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                l10n.findingDriverPleaseWait,
                style: AppStyles.inter14Regular.copyWith(
                  color: AppColors.color_737784,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 3 – ROUTE INFO CARD
// ═══════════════════════════════════════════════════════════════

class _RouteInfoSection extends StatelessWidget {
  const _RouteInfoSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<FindingDriverBloc, FindingDriverState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(24),
          decoration: ShapeDecoration(
            color: AppColors.color_F3F3F6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: Column(
            children: [
              // Pickup row
              _RouteRow(
                icon: AppImages.icDotGrown,
                label: l10n.findingDriverPickupLabel,
                address: state.pickupAddress,
                isPickup: true,
              ),
              // Connector line
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 2,
                    height: 20,
                    color: AppColors.color_E8E8EA,
                  ),
                ),
              ),
              // Destination row
              _RouteRow(
                icon: AppImages.icLocation,
                label: l10n.findingDriverDestLabel,
                address: state.destinationAddress,
                isPickup: false,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 4 – ESTIMATE CARDS (PRICE + DISTANCE)
// ═══════════════════════════════════════════════════════════════

class _EstimateCardsSection extends StatelessWidget {
  const _EstimateCardsSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<FindingDriverBloc, FindingDriverState>(
      builder: (context, state) {
        final formattedPrice = state.estimatedPrice.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Price card
              Expanded(
                child: _EstimateCard(
                  label: l10n.findingDriverEstPrice,
                  value: '$formattedPrice',
                  unit: ' đ',
                  bgColor: AppColors.color_F3F3F6,
                  valueColor: AppColors.color_1C1E,
                  labelColor: AppColors.color_737784,
                ),
              ),
              const SizedBox(width: 12),
              // Distance card
              Expanded(
                child: _EstimateCard(
                  label: l10n.findingDriverDistance,
                  value: '${state.distance}',
                  unit: ' km',
                  bgColor: AppColors.colorFindingDistanceBg,
                  valueColor: AppColors.colorMain,
                  labelColor: AppColors.colorMain,
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
//  SECTION 5 – CANCEL BUTTON
// ═══════════════════════════════════════════════════════════════

class _CancelButtonSection extends StatelessWidget {
  const _CancelButtonSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => context
          .read<FindingDriverBloc>()
          .add(const FindingDriverCancelSearch()),
      child: Container(
        margin: const EdgeInsets.all(16),
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.color_E2E2E5,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppImages.icClose,
              width: 12,
              height: 12,
              colorFilter: const ColorFilter.mode(
                AppColors.color_1C1E,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              l10n.findingDriverCancel,
              style: AppStyles.inter16SemiBold.copyWith(
                color: AppColors.color_1C1E,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SHARED WIDGETS
// ═══════════════════════════════════════════════════════════════

/// Car icon badge shown on the map.
class _DriverCarIcon extends StatelessWidget {
  const _DriverCarIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.colorMain,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: AppColors.colorShadowMd,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SvgPicture.asset(
        AppImages.icCar,
        width: 20,
        height: 20,
        colorFilter: const ColorFilter.mode(
          AppColors.colorWhite,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

/// Single route row (pickup or destination).
class _RouteRow extends StatelessWidget {
  const _RouteRow({
    required this.icon,
    required this.label,
    required this.address,
    required this.isPickup,
  });

  final String icon;
  final String label;
  final String address;
  final bool isPickup;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Dot / Pin
        SvgPicture.asset(icon),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppStyles.inter11Regular.copyWith(
                  color: AppColors.color_737784,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                address,
                style: AppStyles.inter14SemiBold.copyWith(
                  color: AppColors.color_1C1E,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Estimate info card (price / distance).
class _EstimateCard extends StatelessWidget {
  const _EstimateCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.bgColor,
    required this.valueColor,
    required this.labelColor,
  });

  final String label;
  final String value;
  final String unit;
  final Color bgColor;
  final Color valueColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppStyles.inter12SemiBold.copyWith(
              color: labelColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: AppStyles.inter28Bold.copyWith(
                  color: valueColor,
                ),
              ),
              Text(
                unit,
                style: AppStyles.inter16SemiBold.copyWith(
                  color: valueColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Pulsing dot animation for searching state.
class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: AppColors.colorMain,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
