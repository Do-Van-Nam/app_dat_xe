import 'package:demo_app/core/app_export.dart';

import '../bloc/cart_bloc.dart';

class PromoCodeSection extends StatelessWidget {
  const PromoCodeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => context.read<CartBloc>().add(const PromoCodeTapped()),
      child: Container(
        color: AppColors.colorFFFFFF,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            SvgPicture.asset(
              AppImages.icTag,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.color1A56DB,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n.addPromoCode,
                style: AppStyles.inter14SemiBold
                    .copyWith(color: AppColors.color1A56DB),
              ),
            ),
            SvgPicture.asset(
              AppImages.icChevronRight,
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                AppColors.color1A56DB,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
