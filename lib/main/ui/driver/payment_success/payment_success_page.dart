import 'package:demo_app/core/app_export.dart';
import 'bloc/payment_success_bloc.dart';
import 'widgets/success_hero_icon.dart';
import 'widgets/support_card.dart';
import 'widgets/transaction_detail_card.dart';

// ═══════════════════════════════════════════════════════════════
//  PAGE
// ═══════════════════════════════════════════════════════════════

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({
    super.key,
    this.transaction,
  });

  /// Pass the completed transaction from the previous screen.
  final TransactionDetail? transaction;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentSuccessBloc(transaction: transaction),
      child: const _PaymentSuccessView(),
    );
  }
}

class _PaymentSuccessView extends StatelessWidget {
  const _PaymentSuccessView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<PaymentSuccessBloc, PaymentSuccessState>(
      listener: (context, state) {
        // Navigation is driven by events; nothing to listen here by default.
      },
      child: Scaffold(
        backgroundColor: AppColors.colorF9F9FC,
        appBar: _PaymentSuccessAppBar(title: l10n.napTienAppBarTitle),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              const _HeroSection(),
              const SizedBox(height: 32),
              const _TransactionDetailSection(),
              const SizedBox(height: 20),
              const _SupportSection(),
              const SizedBox(height: 28),
              const _ActionButtonsSection(),
              const SizedBox(height: 24),
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

class _PaymentSuccessAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _PaymentSuccessAppBar({required this.title});
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
          padding: const EdgeInsets.all(18),
          child: SvgPicture.asset(
            AppImages.icArrowBack,
            width: 16,
            height: 16,
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
//  SECTION 1 – HERO (icon + title + sub + amount)
// ═══════════════════════════════════════════════════════════════

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<PaymentSuccessBloc, PaymentSuccessState>(
      builder: (context, state) {
        return Column(
          children: [
            const SuccessHeroIcon(circleSize: 88),
            const SizedBox(height: 24),
            Text(
              l10n.napTienHeroTitle,
              style: AppStyles.inter24Bold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              l10n.napTienHeroSub,
              style: AppStyles.inter14Regular,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            Text(
              state.transaction.amount,
              style: AppStyles.inter36Bold.copyWith(
                color: AppColors.colorTextAmount,
              ),
            ),
          ],
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 2 – TRANSACTION DETAIL CARD
// ═══════════════════════════════════════════════════════════════

class _TransactionDetailSection extends StatelessWidget {
  const _TransactionDetailSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<PaymentSuccessBloc, PaymentSuccessState>(
      builder: (context, state) {
        final tx = state.transaction;

        return TransactionDetailCard(
          sectionLabel: l10n.napTienTxCardTitle,
          statusBadgeLabel: l10n.napTienTxStatusBadge,
          rows: [
            // Tx ID
            TxDetailRow(
              label: l10n.napTienTxIdLabel,
              value: tx.txId,
              valueStyle: AppStyles.inter14Bold,
            ),
            // Time
            TxDetailRow(
              label: l10n.napTienTxTimeLabel,
              value: tx.time,
              valueStyle: AppStyles.inter14SemiBold,
            ),
            // Payment method (with logo)
            TxDetailRow(
              label: l10n.napTienTxMethodLabel,
              value: tx.method,
              valueStyle: AppStyles.inter14SemiBold,
              leadingWidget: _MethodLogo(
                asset: tx.methodLogoAsset,
                label: tx.method,
              ),
            ),
            // Status
            TxDetailRow(
              label: l10n.napTienTxStatusLabel,
              value: tx.statusLabel,
              valueStyle: AppStyles.inter14SemiBold.copyWith(
                color: AppColors.colorTextGreen,
              ),
            ),
          ],
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 3 – SUPPORT CARD
// ═══════════════════════════════════════════════════════════════

class _SupportSection extends StatelessWidget {
  const _SupportSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SupportCard(
      title: l10n.napTienSupportTitle,
      body: l10n.napTienSupportBody,
      onTap: () => context
          .read<PaymentSuccessBloc>()
          .add(const PaymentSuccessSupportTapped()),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 4 – ACTION BUTTONS
// ═══════════════════════════════════════════════════════════════

class _ActionButtonsSection extends StatelessWidget {
  const _ActionButtonsSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Primary: go home
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            // onPressed: () => context
            //     .read<PaymentSuccessBloc>()
            //     .add(const PaymentSuccessGoHomeTapped()),
            onPressed: () => context.go(PATH_HOME),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.colorBtnPrimaryBg,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Text(
              l10n.napTienBtnHome,
              style: AppStyles.inter16SemiBold.copyWith(
                color: AppColors.colorBtnPrimaryText,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Secondary: view history
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => context
                .read<PaymentSuccessBloc>()
                .add(const PaymentSuccessViewHistoryTapped()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.colorBtnSecondaryBg,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Text(
              l10n.napTienBtnHistory,
              style: AppStyles.inter16SemiBold.copyWith(
                color: AppColors.colorBtnSecondaryText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  PRIVATE HELPERS
// ═══════════════════════════════════════════════════════════════

/// Payment method logo – image asset with fallback coloured circle.
class _MethodLogo extends StatelessWidget {
  const _MethodLogo({required this.asset, required this.label});
  final String asset;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.asset(
        asset,
        width: 24,
        height: 24,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.colorMomoBg,
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: Text(
            label.isNotEmpty ? label[0].toUpperCase() : 'M',
            style: AppStyles.inter12SemiBold.copyWith(
              color: AppColors.colorMomoText,
            ),
          ),
        ),
      ),
    );
  }
}
