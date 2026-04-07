import 'package:demo_app/core/app_export.dart';

import '../bloc/wallet_bloc.dart';
import '../wallet_widgets.dart';

class IncomeSection extends StatelessWidget {
  const IncomeSection({super.key});

  String _fmt(int amount) {
    return amount.toString().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (m) => '${m[1]}.',
            ) +
        'đ';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final income = context.select((WalletBloc b) => b.state.income);

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.incomeLabel,
                  style: AppStyles.inter11SemiBold.copyWith(
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _fmt(income),
                  style: AppStyles.inter32ExtraBold,
                ),
              ],
            ),
          ),

          // Wallet icon button
          GestureDetector(
            onTap: () =>
                context.read<WalletBloc>().add(const WalletIconTapped()),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.colorWalletIconBg,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                AppImages.icWallet,
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(
                  AppColors.color1A56DB,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
