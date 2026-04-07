import 'package:demo_app/core/app_export.dart';
import 'bloc/wallet_bloc.dart';
import 'sections/credit_wallet_section.dart';
import 'sections/financial_performance_section.dart';
import 'sections/income_section.dart';
import 'sections/promo_banner_section.dart';
import 'sections/transaction_history_section.dart';
import 'wallet_widgets.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WalletBloc()..add(const WalletLoaded()),
      child: const _WalletView(),
    );
  }
}

class _WalletView extends StatelessWidget {
  const _WalletView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<WalletBloc, WalletState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        // Handle navigation actions triggered by events here if needed.
      },
      child: Scaffold(
        backgroundColor: AppColors.colorWhite,
        appBar: _buildAppBar(context, l10n),
        body: SafeArea(
          top: false,
          child: _buildBody(context),
        ),
      ),
    );
  }

  // ── AppBar ──────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(
      BuildContext context, AppLocalizations l10n) {
    return AppBar(
      backgroundColor: AppColors.colorFFFFFF,
      elevation: 0,
      leadingWidth: 56,
      leading: Padding(
        padding: const EdgeInsets.all(10),
        child: CircleAvatar(
          backgroundImage: const AssetImage('assets/images/driver_avatar.jpg'),
          backgroundColor: AppColors.colorF3F4F6,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.statusOnline,
            style: AppStyles.inter16Bold.copyWith(
              color: AppColors.color1A56DB,
            ),
          ),
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.color2ECC71,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                l10n.statusActive,
                style: AppStyles.inter11SemiBold.copyWith(
                  color: AppColors.color2ECC71,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        SosBadge(
          label: l10n.sos,
          onTap: () => context.read<WalletBloc>().add(const SosTapped()),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset(
              AppImages.icBell,
              width: 22,
              height: 22,
              colorFilter: const ColorFilter.mode(
                AppColors.color1A1A1A,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  // ── Body ────────────────────────────────────────────────────────────────
  Widget _buildBody(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        if (state.status == WalletStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.color1A56DB,
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              // Section 1: Promo banner
              PromoBannerSection(),
              SizedBox(height: 16),

              // Section 2: Income hero card
              IncomeSection(),
              SizedBox(height: 16),

              // Section 3: Credit wallet + top-up
              CreditWalletSection(),
              SizedBox(height: 20),

              // Section 4: Transaction history
              TransactionHistorySection(),
              SizedBox(height: 20),

              // Section 5: Financial performance
              FinancialPerformanceSection(),
              SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
