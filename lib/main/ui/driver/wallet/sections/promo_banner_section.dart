import 'package:demo_app/core/app_export.dart';

import '../bloc/wallet_bloc.dart';
import '../wallet_widgets.dart';

class PromoBannerSection extends StatelessWidget {
  const PromoBannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.colorPromoBg, AppColors.colorPromoBgEnd],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Watermark badge (top-right)
          Positioned(
            right: 0,
            top: -4,
            child: Opacity(
              opacity: 0.2,
              child: SvgPicture.asset(
                AppImages.icBadgeVerify,
                width: 72,
                height: 72,
                colorFilter: const ColorFilter.mode(
                  AppColors.colorFFFFFF,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.colorFFFFFF.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  l10n.promoBadge,
                  style: AppStyles.inter11SemiBold.copyWith(
                    color: AppColors.colorFFFFFF,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                l10n.promoTitle,
                style: AppStyles.inter20Bold.copyWith(
                  color: AppColors.colorFFFFFF,
                ),
              ),
              const SizedBox(height: 14),

              // CTA button
              GestureDetector(
                onTap: () =>
                    context.read<WalletBloc>().add(const UpgradeTapped()),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.colorF5A623,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    l10n.promoUpgradeBtn,
                    style: AppStyles.inter13SemiBold.copyWith(
                      color: AppColors.colorFFFFFF,
                    ),
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
