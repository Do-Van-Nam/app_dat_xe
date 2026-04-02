import 'package:demo_app/core/app_export.dart';
import 'rent_driver_bloc.dart';

// ═══════════════════════════════════════════════════════════════
//  PAGE
// ═══════════════════════════════════════════════════════════════

class RentDriverPage extends StatelessWidget {
  const RentDriverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RentDriverBloc(),
      child: const _RentDriverView(),
    );
  }
}

class _RentDriverView extends StatelessWidget {
  const _RentDriverView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<RentDriverBloc, RentDriverState>(
      listenWhen: (p, c) =>
          p.errorMessage != c.errorMessage || p.currentStep != c.currentStep,
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
        if (state.currentStep == RentDriverStep.confirm) {
          // TODO: navigate to confirmation screen
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.colorBackground,
        appBar: _RentDriverAppBar(title: l10n.laiHoAppBarTitle),
        body: Column(
          children: [
            _StepperSection(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  spacing: 16,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _MapAndRouteSection(),
                    _InfoBannerSection(),
                  ],
                ),
              ),
            ),
            const _BottomBarSection(),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  APP BAR
// ═══════════════════════════════════════════════════════════════

class _RentDriverAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _RentDriverAppBar({required this.title});
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
          color: AppColors.colorTextBlue,
        ),
      ),
      centerTitle: false,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 1 – STEPPER
// ═══════════════════════════════════════════════════════════════

class _StepperSection extends StatelessWidget {
  const _StepperSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<RentDriverBloc, RentDriverState>(
      buildWhen: (p, c) => p.currentStep != c.currentStep,
      builder: (context, state) {
        final isStep1 = state.currentStep == RentDriverStep.inputInfo;
        return Container(
          color: AppColors.colorWhite,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              // Step 1
              _StepIndicator(
                iconPath: AppImages.icStepEdit,
                isActive: isStep1,
              ),
              // Line
              Expanded(
                child: Container(
                  height: 2,
                  color: isStep1
                      ? AppColors.colorStepLineInactive
                      : AppColors.colorStepLine,
                ),
              ),
              // Step 2
              _StepIndicator(
                iconPath: AppImages.icStepCheck,
                isActive: !isStep1,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Subtree of _StepperSection ─────────────────────────────
// Labels row is rendered separately below the icons
// We integrate them inline for simplicity.

// ═══════════════════════════════════════════════════════════════
//  SECTION 2 – MAP + ROUTE CARD
// ═══════════════════════════════════════════════════════════════

class _MapAndRouteSection extends StatelessWidget {
  const _MapAndRouteSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Map preview
          _MapPreviewWidget(locatingLabel: l10n.laiHoMapLocating),
          const SizedBox(height: 16),

          // Pickup row
          Text(
            l10n.laiHoPickupLabel,
            style: AppStyles.inter11Regular.copyWith(
              color: AppColors.colorEstimateLabel,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          _PickupRow(
            name: l10n.laiHoPickupName,
            address: l10n.laiHoPickupAddress,
          ),

          // Vertical route connector
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child:
                Container(width: 1, height: 20, color: AppColors.colorDivider),
          ),

          // Destination row
          Text(
            l10n.laiHoDestinationLabel,
            style: AppStyles.inter11Regular.copyWith(
              color: AppColors.colorEstimateLabel,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          _DestinationRow(
            hint: l10n.laiHoDestinationHint,
            cta: l10n.laiHoDestinationCta,
          ),

          const SizedBox(height: 16),

          // Suggestions
          Text(
            l10n.laiHoSuggestionTitle,
            style: AppStyles.inter11Regular.copyWith(
              color: AppColors.colorEstimateLabel,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          _SuggestionRow(
            items: [
              _SuggestionItem(
                iconPath: AppImages.icClock,
                label: l10n.laiHoSuggestionAirport,
              ),
              _SuggestionItem(
                iconPath: AppImages.icHome,
                label: l10n.laiHoSuggestionHome,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 3 – INFO BANNER
// ═══════════════════════════════════════════════════════════════

class _InfoBannerSection extends StatelessWidget {
  const _InfoBannerSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.colorInfoBannerBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.colorInfoBannerBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              AppImages.icShieldCheck,
              width: 22,
              height: 22,
              colorFilter: const ColorFilter.mode(
                AppColors.colorInfoIconFg,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.laiHoInfoTitle,
                    style: AppStyles.inter14SemiBold.copyWith(
                      color: AppColors.colorTextYellow,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.laiHoInfoBody,
                    style: AppStyles.inter13Regular,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  BOTTOM BAR SECTION
// ═══════════════════════════════════════════════════════════════

class _BottomBarSection extends StatelessWidget {
  const _BottomBarSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        14,
        20,
        14 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.colorBottomBarBg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.colorShadowMd,
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Estimate row
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.laiHoEstimateLabel,
                    style: AppStyles.inter11Regular.copyWith(
                      color: AppColors.colorEstimateLabel,
                      letterSpacing: 0.5,
                    ),
                  ),
                  BlocBuilder<RentDriverBloc, RentDriverState>(
                    buildWhen: (p, c) =>
                        p.estimatedPrice != c.estimatedPrice ||
                        p.destination != c.destination,
                    builder: (context, state) {
                      return Text(
                        state.estimatedPrice ?? l10n.laiHoEstimateWaiting,
                        style: AppStyles.inter20Bold.copyWith(
                          color: AppColors.colorMain,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const Spacer(),
              // Promo button
              GestureDetector(
                onTap: () => context
                    .read<RentDriverBloc>()
                    .add(const RentDriverPromoTapped()),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.color_F3F3F6,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppImages.icVoucher,
                        width: 18,
                        height: 18,
                        colorFilter: const ColorFilter.mode(
                          AppColors.colorYellow,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.laiHoPromoLabel,
                        style: AppTextFonts.interSemiBold.copyWith(
                            color: AppColors.colorTextYellow, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Continue button
          BlocBuilder<RentDriverBloc, RentDriverState>(
            buildWhen: (p, c) =>
                p.isLoading != c.isLoading || p.canContinue != c.canContinue,
            builder: (context, state) {
              final enabled = state.canContinue && !state.isLoading;
              return SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: enabled
                      ? () => context
                          .read<RentDriverBloc>()
                          .add(const RentDriverContinueTapped())
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.colorButtonBg,
                    disabledBackgroundColor: AppColors.colorButtonDisabledBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: state.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.colorButtonText,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.laiHoContinueButton,
                              style: AppStyles.inter16SemiBold.copyWith(
                                color: AppColors.colorButtonText,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward,
                              color: AppColors.colorButtonText,
                              size: 20,
                            ),
                          ],
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SHARED WIDGETS
// ═══════════════════════════════════════════════════════════════

/// White card wrapper used in section 2.
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.color_F3F3F6,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.colorShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Circular step indicator with icon and active/inactive state.
class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.iconPath,
    required this.isActive,
  });

  final String iconPath;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            isActive ? AppColors.colorStepActive : AppColors.colorStepInactive,
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        iconPath,
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

/// Map thumbnail with a "Đang định vị..." badge.
class _MapPreviewWidget extends StatelessWidget {
  const _MapPreviewWidget({required this.locatingLabel});
  final String locatingLabel;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RentDriverBloc, RentDriverState>(
      buildWhen: (p, c) => p.locationStatus != c.locationStatus,
      builder: (context, state) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Map image placeholder
              Container(
                width: double.infinity,
                height: 180,
                color: const Color(0xFF3A8FA0),
                child: Image.asset(
                  'assets/images/img_map_preview.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.expand(),
                ),
              ),
              // Locating badge (visible while locating)
              if (state.locationStatus == RentDriverLocationStatus.locating)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.colorMapBadgeBg,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.colorShadow,
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.colorMapDotGreen,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          locatingLabel,
                          style: AppStyles.inter13Medium,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Pickup address row with pin icon and crosshair action.
class _PickupRow extends StatelessWidget {
  const _PickupRow({required this.name, required this.address});
  final String name;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.colorWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.colorShadow,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Blue pin icon bg
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.colorAddressIconBg,
              borderRadius: BorderRadius.circular(999),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppImages.icPinBlue,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.colorPrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppStyles.inter14SemiBold),
                const SizedBox(height: 2),
                Text(address, style: AppStyles.inter12Regular),
              ],
            ),
          ),
          SvgPicture.asset(
            AppImages.icCrosshair,
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(
              AppColors.colorTextSecondary,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}

/// Destination selector row (empty state – tap to choose).
class _DestinationRow extends StatelessWidget {
  const _DestinationRow({required this.hint, required this.cta});
  final String hint;
  final String cta;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context
          .read<RentDriverBloc>()
          .add(const RentDriverDestinationRowTapped()),
      child: BlocBuilder<RentDriverBloc, RentDriverState>(
        buildWhen: (p, c) => p.destination != c.destination,
        builder: (context, state) {
          final hasDestination = state.destination.isNotEmpty;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.color_E2E2E5.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.colorBorder),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.color_E2E2E5,
                  child: SvgPicture.asset(
                    AppImages.icFlag,
                    width: 22,
                    height: 22,
                    colorFilter: const ColorFilter.mode(
                      AppColors.colorTextSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: hasDestination
                      ? Text(
                          state.destination,
                          style: AppStyles.inter14SemiBold,
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(hint, style: AppStyles.inter14Regular),
                            const SizedBox(height: 2),
                            Text(
                              cta,
                              style: AppStyles.inter12SemiBold.copyWith(
                                color: AppColors.colorTextBlue,
                              ),
                            ),
                          ],
                        ),
                ),
                SvgPicture.asset(
                  AppImages.icArrowRight,
                  width: 18,
                  height: 18,
                  colorFilter: const ColorFilter.mode(
                    AppColors.colorTextSecondary,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Horizontal list of nearby suggestion chips.
class _SuggestionRow extends StatelessWidget {
  const _SuggestionRow({required this.items});
  final List<_SuggestionItem> items;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _SuggestionChip(item: item),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _SuggestionItem {
  const _SuggestionItem({required this.iconPath, required this.label});
  final String iconPath;
  final String label;
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.item});
  final _SuggestionItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context
          .read<RentDriverBloc>()
          .add(RentDriverSuggestionTapped(item.label)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.colorChipBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.colorChipBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              item.iconPath,
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(
                AppColors.colorTextSecondary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              item.label,
              style: AppStyles.inter13Medium.copyWith(
                color: AppColors.colorChipText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
