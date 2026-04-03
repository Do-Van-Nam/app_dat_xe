import 'package:demo_app/core/app_export.dart';

import 'shipping_bloc.dart';

// ═══════════════════════════════════════════════════════════════
//  PAGE
// ═══════════════════════════════════════════════════════════════

class ShippingPage extends StatelessWidget {
  const ShippingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShippingBloc(),
      child: const _ShippingView(),
    );
  }
}

class _ShippingView extends StatelessWidget {
  const _ShippingView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<ShippingBloc, ShippingState>(
      listenWhen: (p, c) =>
          p.status != c.status || p.errorMessage != c.errorMessage,
      listener: (context, state) {
        if (state.status == ShippingStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
        if (state.status == ShippingStatus.success) {
          // TODO: navigate to tracking screen
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.colorBackground,
        appBar: _ShippingAppBar(title: l10n.giaoHangAppBarTitle),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 12),
                    _AddressSection(),
                    SizedBox(height: 16),
                    _ServiceSection(),
                    SizedBox(height: 16),
                    _MapSection(),
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

class _ShippingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ShippingAppBar({required this.title});
  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.colorWhite,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
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
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 1 – ADDRESS (pickup + delivery points + options)
// ═══════════════════════════════════════════════════════════════

class _AddressSection extends StatelessWidget {
  const _AddressSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _SectionCard(
      child: BlocBuilder<ShippingBloc, ShippingState>(
        buildWhen: (p, c) =>
            p.deliveryPoints != c.deliveryPoints ||
            p.returnToPickup != c.returnToPickup,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pickup row
              _AddressRow(
                label: l10n.giaoHangPickupLabel,
                address: state.pickupAddress,
                dotWidget: _PickupDot(),
              ),

              // Connector line
              _RouteDivider(),

              // Delivery points
              ...List.generate(state.deliveryPoints.length, (i) {
                return Column(
                  children: [
                    _AddressRow(
                      label: l10n.giaoHangDeliveryLabel,
                      address: state.deliveryPoints[i],
                      dotWidget: _DeliveryPin(),
                    ),
                    if (i < state.deliveryPoints.length - 1) _RouteDivider(),
                  ],
                );
              }),

              const SizedBox(height: 16),
              const _SectionDivider(),
              const SizedBox(height: 12),

              // Add delivery point
              GestureDetector(
                onTap: () {
                  // TODO: open address picker, then dispatch ShippingAddDeliveryPoint
                  context.read<ShippingBloc>().add(
                        const ShippingAddDeliveryPoint('Địa chỉ mới'),
                      );
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AppImages.icAddPoint,
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        AppColors.colorTextAddPoint,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.giaoHangAddPoint,
                      style: AppStyles.inter14SemiBold.copyWith(
                        color: AppColors.colorTextAddPoint,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Return to pickup checkbox
              GestureDetector(
                onTap: () => context
                    .read<ShippingBloc>()
                    .add(const ShippingReturnToPickupToggled()),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      state.returnToPickup
                          ? AppImages.icCheckboxOn
                          : AppImages.icCheckboxOff,
                      width: 22,
                      height: 22,
                      colorFilter: ColorFilter.mode(
                        state.returnToPickup
                            ? AppColors.colorCheckboxChecked
                            : AppColors.colorCheckboxBorder,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      l10n.giaoHangReturnPickup,
                      style: AppStyles.inter14Regular.copyWith(
                        color: AppColors.colorTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 2 – SERVICE PACKAGES
// ═══════════════════════════════════════════════════════════════

class _ServiceSection extends StatelessWidget {
  const _ServiceSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.giaoHangServiceTitle,
            style: AppStyles.inter11SemiBold.copyWith(
              color: AppColors.colorTextSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          BlocBuilder<ShippingBloc, ShippingState>(
            buildWhen: (p, c) => p.selectedService != c.selectedService,
            builder: (context, state) {
              return Column(
                children: [
                  _ServiceCard(
                    iconPath: AppImages.icBolt,
                    name: l10n.giaoHangServiceFastName,
                    sub: l10n.giaoHangServiceFastSub,
                    price: l10n.giaoHangServiceFastPrice,
                    originalPrice: l10n.giaoHangServiceFastOriginalPrice,
                    isSelected:
                        state.selectedService == ShippingServiceType.sieu_toc,
                    onTap: () => context.read<ShippingBloc>().add(
                        const ShippingServiceSelected(
                            ShippingServiceType.sieu_toc)),
                  ),
                  const SizedBox(height: 10),
                  _ServiceCard(
                    iconPath: AppImages.icClock,
                    name: l10n.giaoHangServiceEcoName,
                    sub: l10n.giaoHangServiceEcoSub,
                    price: l10n.giaoHangServiceEcoPrice,
                    originalPrice: l10n.giaoHangServiceEcoOriginalPrice,
                    isSelected:
                        state.selectedService == ShippingServiceType.sieu_rp_2h,
                    onTap: () => context.read<ShippingBloc>().add(
                        const ShippingServiceSelected(
                            ShippingServiceType.sieu_rp_2h)),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 3 – MAP PREVIEW
// ═══════════════════════════════════════════════════════════════

class _MapSection extends StatelessWidget {
  const _MapSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ShippingBloc, ShippingState>(
      buildWhen: (p, c) => p.estimatedDistance != c.estimatedDistance,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Map image
                Container(
                  width: double.infinity,
                  height: 200,
                  color: const Color(0xFFD6E8C8),
                  child: Image.asset(
                    'assets/images/img_map_preview.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.expand(),
                  ),
                ),
                // Map pin overlay
                const Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 30,
                  child: Center(child: _MapPinWidget()),
                ),
                // Distance badge
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    color: AppColors.colorMapDistanceBg.withOpacity(0.92),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          AppImages.icNavigation,
                          width: 16,
                          height: 16,
                          colorFilter: const ColorFilter.mode(
                            AppColors.colorMapDotIndicator,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${l10n.giaoHangMapDistance.replaceAll('4.2 km', state.estimatedDistance)}',
                          style: AppStyles.inter13SemiBold.copyWith(
                            color: AppColors.colorMapDistanceText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
      decoration: const BoxDecoration(
        color: AppColors.colorWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.colorShadowMd,
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Payment + discount + total row
              BlocBuilder<ShippingBloc, ShippingState>(
                buildWhen: (p, c) =>
                    p.paymentMethod != c.paymentMethod ||
                    p.discountLabel != c.discountLabel ||
                    p.totalPrice != c.totalPrice,
                builder: (context, state) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Cash icon + label
                      GestureDetector(
                        onTap: () => context
                            .read<ShippingBloc>()
                            .add(const ShippingPaymentMethodTapped()),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AppImages.icCash,
                              width: 20,
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                AppColors.colorTextPrimary,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              state.paymentMethod,
                              style: AppStyles.inter14Medium,
                            ),
                          ],
                        ),
                      ),

                      // Vertical divider
                      Container(
                        width: 1,
                        height: 18,
                        color: AppColors.colorPaymentDivider,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                      ),

                      // Discount badge
                      _DiscountBadge(label: state.discountLabel),

                      const Spacer(),

                      // Total
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            l10n.giaoHangTotalLabel,
                            style: AppStyles.inter11Regular.copyWith(
                              color: AppColors.colorTotalLabel,
                              letterSpacing: 0.4,
                            ),
                          ),
                          Text(
                            state.totalPrice,
                            style: AppStyles.inter18Bold.copyWith(
                              color: AppColors.colorTotalValue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 12),

              // Buttons row
              BlocBuilder<ShippingBloc, ShippingState>(
                buildWhen: (p, c) => p.status != c.status,
                builder: (context, state) {
                  final isLoading = state.status == ShippingStatus.loading;
                  return Row(
                    children: [
                      // Add info button (full width)
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () => context.push(PATH_DELIVERY_INFO),
                            //     () => context
                            //         .read<ShippingBloc>()
                            //         .add(const ShippingAddInfoTapped()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.colorBtnAddInfoBg,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  AppImages.icNoteEdit,
                                  width: 18,
                                  height: 18,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.colorBtnAddInfoText,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.giaoHangBtnAddInfo,
                                  style: AppStyles.inter14SemiBold.copyWith(
                                    color: AppColors.colorBtnAddInfoText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 10),

              // Schedule + Order Now row
              BlocBuilder<ShippingBloc, ShippingState>(
                buildWhen: (p, c) => p.status != c.status,
                builder: (context, state) {
                  final isLoading = state.status == ShippingStatus.loading;
                  return Row(
                    children: [
                      // Schedule icon button
                      GestureDetector(
                        onTap: () => context
                            .read<ShippingBloc>()
                            .add(const ShippingScheduleTapped()),
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.colorBtnScheduleBg,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            AppImages.icSchedule,
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              AppColors.colorBtnScheduleIcon,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Order now button
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () => context
                                    .read<ShippingBloc>()
                                    .add(const ShippingOrderNowTapped()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.colorBtnOrderBg,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: AppColors.colorBtnOrderText,
                                    ),
                                  )
                                : Text(
                                    l10n.giaoHangBtnOrder,
                                    style: AppStyles.inter16SemiBold.copyWith(
                                      color: AppColors.colorBtnOrderText,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SHARED WIDGETS
// ═══════════════════════════════════════════════════════════════

/// White card container wrapping each main section.
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.colorCardBg,
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

/// Single address row with dot/pin, label, and address text.
class _AddressRow extends StatelessWidget {
  const _AddressRow({
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        dotWidget,
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
              const SizedBox(height: 2),
              Text(address, style: AppStyles.inter16SemiBold),
            ],
          ),
        ),
      ],
    );
  }
}

/// Blue circle dot for pickup point.
class _PickupDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.colorPrimaryLight,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.colorDotPickup,
        ),
      ),
    );
  }
}

/// Red pin icon for delivery point.
class _DeliveryPin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: SvgPicture.asset(
        AppImages.icPinDelivery,
        colorFilter: const ColorFilter.mode(
          AppColors.colorDotDelivery,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

/// Vertical connector line between route points.
class _RouteDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 13, top: 4, bottom: 4),
      child: Container(
        width: 2,
        height: 24,
        color: AppColors.colorRouteLine,
      ),
    );
  }
}

/// Thin horizontal section divider.
class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: AppColors.colorBorder,
      thickness: 1,
      height: 1,
    );
  }
}

/// Service package selection card.
class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.iconPath,
    required this.name,
    required this.sub,
    required this.price,
    required this.originalPrice,
    required this.isSelected,
    required this.onTap,
  });

  final String iconPath;
  final String name;
  final String sub;
  final String price;
  final String originalPrice;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.colorCardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.colorBorderServiceSelected
                : AppColors.colorBorderServiceNormal,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon box
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.colorServiceIconBgSelected
                    : AppColors.colorServiceIconBgNormal,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                iconPath,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  isSelected
                      ? AppColors.colorPrimary
                      : AppColors.colorTextSecondary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Name + sub
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppStyles.inter16SemiBold),
                  const SizedBox(height: 2),
                  Text(sub, style: AppStyles.inter13Regular),
                ],
              ),
            ),

            // Price column
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: AppStyles.inter16Bold.copyWith(
                    color: AppColors.colorPrimary,
                  ),
                ),
                Text(
                  originalPrice,
                  style: AppStyles.inter12Regular.copyWith(
                    color: AppColors.colorTextStrike,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Map pin widget shown on map preview.
class _MapPinWidget extends StatelessWidget {
  const _MapPinWidget();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppImages.icMapPin,
      width: 48,
      height: 48,
      colorFilter: const ColorFilter.mode(
        AppColors.colorPrimary,
        BlendMode.srcIn,
      ),
    );
  }
}

/// Discount badge chip.
class _DiscountBadge extends StatelessWidget {
  const _DiscountBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.colorDiscountBadgeBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.colorDiscountBadgeBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppImages.icVoucher,
            width: 14,
            height: 14,
            colorFilter: const ColorFilter.mode(
              AppColors.colorDiscountBadgeText,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppStyles.inter12SemiBold.copyWith(
              color: AppColors.colorDiscountBadgeText,
            ),
          ),
        ],
      ),
    );
  }
}
