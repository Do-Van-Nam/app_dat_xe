import 'package:demo_app/core/app_export.dart';

import '../bloc/checkout_bloc.dart';
import '../checkout_models.dart';
import '../checkout_widgets.dart';

class PromoCodeSection extends StatelessWidget {
  const PromoCodeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(l10n.promoSection),
        const SizedBox(height: 10),
        _PromoInputRow(),
      ],
    );
  }
}

class _PromoInputRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.colorPromoInputBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.colorBorder),
      ),
      child: Row(
        children: [
          // Ticket icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.colorPromoIconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppImages.icTicket,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.colorFFFFFF,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Text input
          Expanded(
            child: TextField(
              onChanged: (v) =>
                  context.read<CheckoutBloc>().add(PromoCodeChanged(v)),
              style: AppStyles.inter14Regular,
              decoration: InputDecoration(
                hintText: l10n.promoHint,
                hintStyle: AppStyles.inter14Regular
                    .copyWith(color: AppColors.colorBDBDBD),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Apply button
          GestureDetector(
            onTap: () =>
                context.read<CheckoutBloc>().add(const PromoCodeApplied()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.colorEBF3FF,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                l10n.apply,
                style: AppStyles.inter13Medium
                    .copyWith(color: AppColors.color1A56DB),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
