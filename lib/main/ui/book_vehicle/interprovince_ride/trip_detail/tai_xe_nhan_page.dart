import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/data/model/ride/ride.dart';

import 'tai_xe_nhan_bloc.dart';
import 'widgets/app_icon_button.dart';
import 'widgets/app_outlined_card.dart';
import 'widgets/route_row.dart';
import 'widgets/section_label.dart';

// ═══════════════════════════════════════════════════════════════
//  PAGE
// ═══════════════════════════════════════════════════════════════

class TripDetailPage extends StatelessWidget {
  const TripDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TripDetailBloc(),
      child: const _TripDetailView(),
    );
  }
}

class _TripDetailView extends StatelessWidget {
  const _TripDetailView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<TripDetailBloc, TripDetailState>(
      listenWhen: (p, c) =>
          p.status != c.status || p.errorMessage != c.errorMessage,
      listener: (context, state) {
        if (state.status == TripDetailStatus.error &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
        if (state.status == TripDetailStatus.cancelled) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.colorBackground,
        appBar: _TripDetailAppBar(title: l10n.taiXeNhanAppBarTitle),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _NotificationBannerSection(),
              SizedBox(height: 16),
              _DriverCardSection(),
              SizedBox(height: 16),
              _CarInfoSection(),
              SizedBox(height: 16),
              _ActionButtonsSection(),
              SizedBox(height: 20),
              _TripDetailSection(),
              SizedBox(height: 16),
              _MapBannerSection(),
              SizedBox(height: 20),
              _CancelButtonSection(),
              SizedBox(height: 24),
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

class _TripDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _TripDetailAppBar({required this.title});
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
        child: Container(height: 1, color: AppColors.colorAppBarDivider),
      ),
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SvgPicture.asset(
            AppImages.icArrowBack,
            width: 6,
            height: 6,
            colorFilter: const ColorFilter.mode(
              AppColors.colorAppBarTitle,
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
              .read<TripDetailBloc>()
              .add(const TripDetailMoreOptionsTapped()),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SvgPicture.asset(
              AppImages.icMoreDots,
              width: 6,
              height: 6,
              colorFilter: const ColorFilter.mode(
                AppColors.colorAppBarTitle,
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
//  SECTION 1 – NOTIFICATION BANNER
// ═══════════════════════════════════════════════════════════════

class _NotificationBannerSection extends StatelessWidget {
  const _NotificationBannerSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.colorBannerBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.colorBannerBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Check icon circle
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: AppColors.colorBannerIconBg,
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppImages.icCheckCircle,
              width: 22,
              height: 22,
              colorFilter: const ColorFilter.mode(
                AppColors.colorBannerIcon,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.taiXeNhanBannerTitle,
                  style: AppStyles.inter15SemiBold.copyWith(
                    color: AppColors.colorTextBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.taiXeNhanBannerBody,
                  style: AppStyles.inter13Regular,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 2 – DRIVER CARD
// ═══════════════════════════════════════════════════════════════

class _DriverCardSection extends StatelessWidget {
  const _DriverCardSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<TripDetailBloc, TripDetailState>(
      buildWhen: (p, c) => p.driver != c.driver,
      builder: (context, state) {
        final driver = state.driver;
        return AppOutlinedCard(
          child: Column(
            children: [
              // Avatar + verified badge
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: AppColors.colorSectionBg,
                    backgroundImage: driver.avatarUrl.isNotEmpty
                        ? NetworkImage(driver.avatarUrl)
                        : null,
                    child: driver.avatarUrl.isEmpty
                        ? const Icon(Icons.person,
                            size: 44, color: AppColors.colorTextSecondary)
                        : null,
                  ),
                  if (driver.isVerified)
                    Positioned(
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.colorVerifiedBadgeBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          l10n.taiXeNhanVerified,
                          style: AppStyles.inter11SemiBold.copyWith(
                            color: AppColors.colorVerifiedText,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),

              // Name
              Text(
                driver.name,
                style: AppStyles.inter20Bold,
              ),
              const SizedBox(height: 4),

              // Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppImages.icStar,
                    width: 16,
                    height: 16,
                    colorFilter: const ColorFilter.mode(
                      AppColors.colorStarIcon,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${driver.rating} (${driver.tripCount})',
                    style: AppStyles.inter14SemiBold.copyWith(
                      color: AppColors.colorTextYellow,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // License plate
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.color_F3F3F6,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.colorLicensePlateBorder),
                ),
                child: Column(
                  children: [
                    Text(
                      l10n.taiXeNhanLicensePlateLabel,
                      style: AppStyles.inter11Regular.copyWith(
                        color: AppColors.colorLicensePlateLabel,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      driver.licensePlate,
                      style: AppStyles.inter20Bold,
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
//  SECTION 3 – CAR INFO
// ═══════════════════════════════════════════════════════════════

class _CarInfoSection extends StatelessWidget {
  const _CarInfoSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<TripDetailBloc, TripDetailState>(
      buildWhen: (p, c) => p.driver.carModel != c.driver.carModel,
      builder: (context, state) {
        return AppOutlinedCard(
          color: AppColors.colorCarInfoBg,
          borderColor: AppColors.colorCarInfoBorder,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    AppImages.icCar,
                    width: 22,
                    height: 22,
                    colorFilter: const ColorFilter.mode(
                      AppColors.colorCarInfoIcon,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    state.driver.carModel,
                    style: AppStyles.inter16SemiBold.copyWith(
                      color: AppColors.colorTextBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                state.driver.carNote,
                style: AppStyles.inter13Regular.copyWith(
                  color: AppColors.colorCarInfoQuote,
                  fontStyle: FontStyle.italic,
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
//  SECTION 4 – ACTION BUTTONS (call + message)
// ═══════════════════════════════════════════════════════════════

class _ActionButtonsSection extends StatelessWidget {
  const _ActionButtonsSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        AppIconButton(
          label: l10n.taiXeNhanBtnCall,
          iconPath: AppImages.icPhone,
          bgColor: AppColors.colorBtnCallBg,
          textColor: AppColors.colorBtnCallText,
          iconColor: AppColors.colorBtnCallText,
          onTap: () => context
              .read<TripDetailBloc>()
              .add(const TripDetailCallDriverTapped()),
        ),
        const SizedBox(height: 10),
        AppIconButton(
          label: l10n.taiXeNhanBtnMessage,
          iconPath: AppImages.icMessage,
          bgColor: AppColors.colorBtnMsgBg,
          textColor: AppColors.colorBtnMsgText,
          iconColor: AppColors.colorBtnMsgText,
          onTap: () => context
              .read<TripDetailBloc>()
              .add(const TripDetailMessageDriverTapped()),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 5 – TRIP DETAIL (route + total + payment)
// ═══════════════════════════════════════════════════════════════

class _TripDetailSection extends StatelessWidget {
  const _TripDetailSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<TripDetailBloc, TripDetailState>(
      buildWhen: (p, c) => p.trip != c.trip,
      builder: (context, state) {
        final trip = state.trip;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionLabel(label: l10n.taiXeNhanTripDetailLabel),
            const SizedBox(height: 10),
            AppOutlinedCard(
              child: Column(
                children: [
                  // Pickup
                  RouteRow(
                    dotColor: AppColors.colorDotPickup,
                    dotBorderColor: AppColors.colorDotPickup,
                    label: l10n.taiXeNhanPickupLabel,
                    address: trip.pickupAddress,
                    subText: trip.pickupTime,
                  ),

                  // Connector line
                  Padding(
                    padding: const EdgeInsets.only(left: 9),
                    child: Row(
                      children: [
                        Container(
                          width: 2,
                          height: 20,
                          color: AppColors.colorRouteLine,
                        ),
                      ],
                    ),
                  ),

                  // Destination
                  RouteRow(
                    dotColor: AppColors.colorDotDestination,
                    dotBorderColor: AppColors.colorDotDestination,
                    label: l10n.taiXeNhanDestinationLabel,
                    address: trip.destinationAddress,
                    subText: trip.destinationETA,
                  ),

                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppColors.colorBorder),
                  const SizedBox(height: 14),

                  // Total + payment
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.taiXeNhanTotalLabel,
                            style: AppStyles.inter11Regular.copyWith(
                              color: AppColors.colorTotalLabel,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            trip.totalPrice,
                            style: AppStyles.inter22Bold.copyWith(
                              color: AppColors.colorTotalValue,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: ShapeDecoration(
                          color: AppColors.color_F3F3F6,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AppImages.icWallet2,
                              width: 18,
                              height: 18,
                              colorFilter: const ColorFilter.mode(
                                AppColors.colorPaymentIcon,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              trip.paymentMethod,
                              style: AppStyles.inter14Medium.copyWith(
                                color: AppColors.colorTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 6 – MAP BANNER (driver photo + view map CTA)
// ═══════════════════════════════════════════════════════════════

class _MapBannerSection extends StatelessWidget {
  const _MapBannerSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () =>
          context.read<TripDetailBloc>().add(const TripDetailViewMapTapped()),
      child: BlocBuilder<TripDetailBloc, TripDetailState>(
        buildWhen: (p, c) => p.driver.avatarUrl != c.driver.avatarUrl,
        builder: (context, state) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Driver photo background
                Container(
                  width: double.infinity,
                  height: 160,
                  color: AppColors.colorSectionBg,
                  child: state.driver.avatarUrl.isNotEmpty
                      ? Image.network(
                          state.driver.avatarUrl,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/img_driver_banner.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox.expand(),
                        ),
                ),
                // "View map" pill badge
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.colorMapBannerBg,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.colorShadowMd,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          AppImages.icNavigation,
                          width: 16,
                          height: 16,
                          colorFilter: const ColorFilter.mode(
                            AppColors.colorMapBannerIcon,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.taiXeNhanMapBanner,
                          style: AppStyles.inter13SemiBold.copyWith(
                            color: AppColors.colorMapBannerText,
                          ),
                        ),
                      ],
                    ),
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

// ═══════════════════════════════════════════════════════════════
//  SECTION 7 – CANCEL BUTTON
// ═══════════════════════════════════════════════════════════════

class _CancelButtonSection extends StatelessWidget {
  const _CancelButtonSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<TripDetailBloc, TripDetailState>(
      buildWhen: (p, c) => p.status != c.status,
      builder: (context, state) {
        final isLoading = state.status == TripDetailStatus.cancelling;
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed:
                isLoading ? null : () => _showCancelDialog(context, l10n),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.white,
            ),
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.colorCancelText,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppImages.icXCircle,
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          AppColors.colorCancelIcon,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.taiXeNhanCancelButton,
                        style: AppStyles.inter16SemiBold.copyWith(
                          color: AppColors.colorCancelIcon,
                        ),
                      ),
                    ],
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
        title: Center(
          child: Container(
            padding: const EdgeInsets.all(12),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.colorCancelBg2,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SvgPicture.asset(
              AppImages.icWarning,
              width: 8,
              height: 8,
              colorFilter: const ColorFilter.mode(
                AppColors.colorCancelIcon,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              l10n.titleHuyChuyen,
              style: AppStyles.inter18Bold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.contentHuyChuyen,
              style: AppStyles.inter14Regular,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context
                      .read<TripDetailBloc>()
                      .add(const TripDetailCallDriverTapped());
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.colorMain,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  side: const BorderSide(color: AppColors.colorPrimaryDark),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(AppImages.icPhone),
                    const SizedBox(width: 8),
                    Text(
                      l10n.btnGoiTaiXe,
                      style: AppStyles.inter14SemiBold.copyWith(
                        color: AppColors.colorWhite,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  side: BorderSide(color: Colors.grey.shade300, width: 2),
                ),
                child: Text(
                  l10n.btnDong,
                  style: AppStyles.inter14SemiBold.copyWith(
                    color: AppColors.colorTextSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
