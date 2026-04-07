import 'package:demo_app/core/app_export.dart';

import 'bloc/service_register_bloc.dart';
import 'widgets/notice_card.dart';
import 'widgets/service_toggle_card.dart';

// ═══════════════════════════════════════════════════════════════
//  PAGE
// ═══════════════════════════════════════════════════════════════

class ServiceRegisterPage extends StatelessWidget {
  const ServiceRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ServiceRegisterBloc(),
      child: const _ServiceRegisterView(),
    );
  }
}

class _ServiceRegisterView extends StatelessWidget {
  const _ServiceRegisterView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<ServiceRegisterBloc, ServiceRegisterState>(
      listenWhen: (p, c) =>
          p.status != c.status || p.errorMessage != c.errorMessage,
      listener: (context, state) {
        if (state.status == ServiceRegisterStatus.error &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
        if (state.status == ServiceRegisterStatus.submitted) {
          // TODO: navigate to next step / success screen
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.colorBackground,
        appBar: _ServiceRegisterAppBar(title: l10n.dangKyDvAppBarTitle),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _BannerSection(),
                    SizedBox(height: 24),
                    _ServiceHeaderSection(),
                    SizedBox(height: 14),
                    _ServiceListSection(),
                    SizedBox(height: 20),
                    _NoticeSection(),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            const _ConfirmButtonSection(),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  APP BAR
// ═══════════════════════════════════════════════════════════════

class _ServiceRegisterAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _ServiceRegisterAppBar({required this.title});
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
            width: 24,
            height: 24,
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
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 1 – HERO BANNER
// ═══════════════════════════════════════════════════════════════

class _BannerSection extends StatelessWidget {
  const _BannerSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.colorPrimaryGradientStart,
              AppColors.colorPrimaryGradientEnd,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Decorative speedometer overlay (image placeholder)
            Positioned(
              right: -20,
              top: -20,
              child: Opacity(
                opacity: 0.12,
                child: Image.asset(
                  'assets/images/img_speedometer.png',
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge chip
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.colorBannerBadgeBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.dangKyDvBannerBadge,
                      style: AppStyles.inter11SemiBold.copyWith(
                        color: AppColors.colorBannerBadgeText,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    l10n.dangKyDvBannerTitle,
                    style: AppStyles.inter22Bold.copyWith(
                      color: AppColors.colorBannerTitle,
                      height: 1.3,
                    ),
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
//  SECTION 2 – SERVICE HEADER (title + sub + "register all" btn)
// ═══════════════════════════════════════════════════════════════

class _ServiceHeaderSection extends StatelessWidget {
  const _ServiceHeaderSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.dangKyDvSectionTitle,
                style: AppStyles.inter20Bold,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.dangKyDvSectionSub,
                style: AppStyles.inter13Regular,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),

        // "Register all" button
        BlocBuilder<ServiceRegisterBloc, ServiceRegisterState>(
          buildWhen: (p, c) => p.allEnabled != c.allEnabled,
          builder: (context, state) {
            return GestureDetector(
              onTap: () => context
                  .read<ServiceRegisterBloc>()
                  .add(const ServiceRegisterRegisterAllTapped()),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                decoration: ShapeDecoration(
                  color: AppColors.colorYellowBtnBg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppImages.icCheckAll,
                      width: 14,
                      height: 14,
                      colorFilter: const ColorFilter.mode(
                        AppColors.colorYellowBtnText,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      l10n.dangKyDvRegisterAll,
                      style: AppStyles.inter13SemiBold.copyWith(
                        color: AppColors.colorYellowBtnText,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 3 – SERVICE LIST (toggleable rows)
// ═══════════════════════════════════════════════════════════════

class _ServiceListSection extends StatelessWidget {
  const _ServiceListSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceRegisterBloc, ServiceRegisterState>(
      buildWhen: (p, c) => p.services != c.services,
      builder: (context, state) {
        return Column(
          children: state.services.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ServiceToggleCard(
                item: item,
                onToggle: () => context
                    .read<ServiceRegisterBloc>()
                    .add(ServiceRegisterServiceToggled(item.id)),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 4 – IMPORTANT NOTICE
// ═══════════════════════════════════════════════════════════════

class _NoticeSection extends StatelessWidget {
  const _NoticeSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return NoticeCard(
      title: l10n.dangKyDvNoticeTitle,
      body: l10n.dangKyDvNoticeBody,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  BOTTOM – CONFIRM BUTTON
// ═══════════════════════════════════════════════════════════════

class _ConfirmButtonSection extends StatelessWidget {
  const _ConfirmButtonSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.of(context).padding.bottom,
      ),
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
      child: BlocBuilder<ServiceRegisterBloc, ServiceRegisterState>(
        buildWhen: (p, c) =>
            p.hasAnyEnabled != c.hasAnyEnabled || p.status != c.status,
        builder: (context, state) {
          final isSubmitting = state.status == ServiceRegisterStatus.submitting;
          final canConfirm = state.hasAnyEnabled && !isSubmitting;

          return SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: canConfirm
                  ? () => context
                      .read<ServiceRegisterBloc>()
                      .add(const ServiceRegisterConfirmTapped())
                  : () => context.push(PATH_WAITING_APPROVAL),
              // : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.colorMain,
                disabledBackgroundColor:
                    AppColors.colorMain.withValues(alpha: 0.5),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.colorConfirmBtnText,
                      ),
                    )
                  : Text(
                      l10n.dangKyDvConfirmButton,
                      style: AppStyles.inter16SemiBold.copyWith(
                        color: AppColors.colorConfirmBtnText,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
