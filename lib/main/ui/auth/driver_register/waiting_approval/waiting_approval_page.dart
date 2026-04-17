import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/utils/widget/app_toast_widget.dart';

import 'bloc/waiting_approval_bloc.dart';
import 'widgets/support_card.dart';
import 'widgets/verification_step_row.dart';

// ═══════════════════════════════════════════════════════════════
//  PAGE
// ═══════════════════════════════════════════════════════════════

class WaitingApprovalPage extends StatelessWidget {
  const WaitingApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WaitingApprovalBloc(),
      child: const _WaitingApprovalView(),
    );
  }
}

class _WaitingApprovalView extends StatelessWidget {
  const _WaitingApprovalView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<WaitingApprovalBloc, WaitingApprovalState>(
      listenWhen: (p, c) => p.pageStatus != c.pageStatus,
      listener: (context, state) {
        if (state.pageStatus == WaitingApprovalPageStatus.approved) {
          // TODO: navigate to home / dashboard screen
          AppToast.show(context, "HO so da duoc duyet");
          context.go(PATH_HOME);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.colorWhite,
        appBar: _WaitingApprovalAppBar(title: l10n.choDuyetAppBarTitle),
        body: Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  children: [
                    const _HeroSection(),
                    const SizedBox(height: 28),
                    const _ProgressCardSection(),
                    const SizedBox(height: 20),
                    _SupportSection(l10n: l10n),
                    const SizedBox(height: 28),
                    _MainButtonSection(l10n: l10n),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Pinned notification bar
            _NotificationBar(l10n: l10n),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  APP BAR
// ═══════════════════════════════════════════════════════════════

class _WaitingApprovalAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _WaitingApprovalAppBar({required this.title});
  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.colorAppBarBg,
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
//  SECTION 1 – HERO (icon + title + body with highlighted text)
// ═══════════════════════════════════════════════════════════════

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Yellow circle with history-clock icon
        Container(
          width: 88,
          height: 88,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.colorHeroCircleBg,
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            AppImages.icHistoryClock,
            width: 44,
            height: 44,
            colorFilter: const ColorFilter.mode(
              AppColors.colorHeroIcon,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Title
        Text(
          l10n.choDuyetHeroTitle,
          textAlign: TextAlign.center,
          style: AppStyles.inter24Bold,
        ),
        const SizedBox(height: 14),

        // Body with inline highlight
        Text.rich(
          TextSpan(
            style: AppStyles.inter15Regular.copyWith(
              color: AppColors.colorTextSecondary,
            ),
            children: [
              TextSpan(text: l10n.choDuyetHeroBodyPrefix),
              TextSpan(
                text: l10n.choDuyetHeroBodyHighlight,
                style: AppStyles.inter15SemiBold.copyWith(
                  color: AppColors.colorTextBlue,
                ),
              ),
              TextSpan(text: l10n.choDuyetHeroBodySuffix),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 2 – PROGRESS CARD
// ═══════════════════════════════════════════════════════════════

class _ProgressCardSection extends StatelessWidget {
  const _ProgressCardSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<WaitingApprovalBloc, WaitingApprovalState>(
      buildWhen: (p, c) => p.steps != c.steps,
      builder: (context, state) {
        return CommonCard(
          padding: const EdgeInsets.all(18),
          margin: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.choDuyetProgressTitle,
                style: AppStyles.inter11SemiBold.copyWith(
                  color: AppColors.colorProgressLabel,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 16),

              // Step rows
              ...state.steps.asMap().entries.map((entry) {
                final isLast = entry.key == state.steps.length - 1;
                return VerificationStepRow(
                  step: entry.value,
                  isLast: isLast,
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 3 – SUPPORT CARD
// ═══════════════════════════════════════════════════════════════

class _SupportSection extends StatelessWidget {
  const _SupportSection({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return SupportCard(
      question: l10n.choDuyetSupportQuestion,
      ctaText: l10n.choDuyetSupportCta,
      onTap: () => context
          .read<WaitingApprovalBloc>()
          .add(const WaitingApprovalSupportTapped()),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 4 – MAIN BUTTON "Quay lại trang chính"
// ═══════════════════════════════════════════════════════════════

class _MainButtonSection extends StatelessWidget {
  const _MainButtonSection({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => context.go(PATH_HOME),
        // context
        //     .read<WaitingApprovalBloc>()
        //     .add(const WaitingApprovalGoHomeTapped()),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.colorBtnBg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          l10n.choDuyetMainButton,
          style: AppStyles.inter16SemiBold.copyWith(
            color: AppColors.colorBtnText,
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  PINNED NOTIFICATION BAR (bottom)
// ═══════════════════════════════════════════════════════════════

class _NotificationBar extends StatelessWidget {
  const _NotificationBar({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        10 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.colorNotifBarBg,
        border: Border(
          top: BorderSide(color: AppColors.colorNotifBarBorder),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppImages.icBell,
            width: 16,
            height: 16,
            colorFilter: const ColorFilter.mode(
              AppColors.colorNotifBarIcon,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              l10n.choDuyetNotifBar,
              style: AppStyles.inter12Regular.copyWith(
                color: AppColors.colorNotifBarText,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
