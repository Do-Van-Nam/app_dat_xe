import 'package:demo_app/core/app_export.dart';

import '../bloc/wallet_bloc.dart';
import '../wallet_widgets.dart';

class CreditWalletSection extends StatelessWidget {
  const CreditWalletSection({super.key});

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
    final state = context.watch<WalletBloc>().state;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label row
          Row(
            children: [
              Text(
                l10n.creditWalletLabel,
                style: AppStyles.inter11SemiBold.copyWith(letterSpacing: 0.6),
              ),
              const SizedBox(width: 8),

              // Low balance badge
              if (state.isLowBalance)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.colorLowBadgeBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    l10n.creditLowBadge,
                    style: AppStyles.inter11SemiBold.copyWith(
                      color: AppColors.colorLowBadgeText,
                    ),
                  ),
                ),

              const Spacer(),

              // Card icon button
              GestureDetector(
                onTap: () =>
                    context.read<WalletBloc>().add(const WalletIconTapped()),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.colorTopUpIconBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    AppImages.icWalletAdd,
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(
                      AppColors.colorF5A623,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Balance amount
          Text(
            _fmt(state.creditBalance),
            style: AppStyles.inter28ExtraBold,
          ),

          const SizedBox(height: 16),

          // Top-up button
          GestureDetector(
            onTap: () => context.read<WalletBloc>().add(const TopUpTapped()),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.colorF5A623,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppImages.icTopUp,
                    width: 16,
                    height: 16,
                    colorFilter: const ColorFilter.mode(
                      AppColors.colorFFFFFF,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.topUpBtn,
                    style: AppStyles.inter15SemiBold.copyWith(
                      color: AppColors.colorFFFFFF,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
