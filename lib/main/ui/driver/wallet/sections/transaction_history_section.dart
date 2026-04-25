import 'package:demo_app/core/app_export.dart';

import '../bloc/wallet_bloc.dart';
import '../wallet_widgets.dart';

class TransactionHistorySection extends StatelessWidget {
  const TransactionHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final recentTransactions = context.select(
        (WalletBloc b) => b.state.walletManageResponse?.recentTransactions);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.transactionHistoryTitle,
              style: AppStyles.inter16Bold,
            ),
            GestureDetector(
              onTap: () => context
                  .read<WalletBloc>()
                  .add(const ViewAllTransactionsTapped()),
              child: Text(
                l10n.viewAll,
                style: AppStyles.inter13Medium.copyWith(
                  color: AppColors.color1A56DB,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Transaction list
        if (recentTransactions == null || recentTransactions.isEmpty)
          const SizedBox(height: 40)
        else
          CommonCard(
            margin: EdgeInsets.zero,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentTransactions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return TransactionTile(tx: recentTransactions[index]);
              },
            ),
          ),
      ],
    );
  }
}
