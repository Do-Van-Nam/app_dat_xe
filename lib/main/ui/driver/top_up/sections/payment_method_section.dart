import 'package:demo_app/core/app_export.dart';

import '../bloc/topup_bloc.dart';
import '../topup_widgets.dart';

class PaymentMethodSection extends StatelessWidget {
  const PaymentMethodSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<TopUpBloc>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.paymentMethodLabel, style: AppStyles.inter11SemiBold),
              GestureDetector(
                onTap: () =>
                    context.read<TopUpBloc>().add(const ChangeMethodTapped()),
                child: Text(
                  l10n.changeMethod,
                  style: AppStyles.inter13Medium.copyWith(
                    color: AppColors.color1A56DB,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Payment list container
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: AppColors.colorF3F3F6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            children: [
              GroupHeader(label: l10n.eWalletGroup),
              ...List.generate(state.eWalletMethods.length, (i) {
                final m = state.eWalletMethods[i];
                return EWalletMethodRow(
                  iconPath: m.iconPath,
                  name: m.name,
                  subLabel: m.subLabel,
                  selected: state.selectedMethodId == m.id,
                  isLast: i == state.eWalletMethods.length - 1,
                  onTap: () => context
                      .read<TopUpBloc>()
                      .add(PaymentMethodSelected(m.id)),
                );
              }),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        // ── Bank group ─────────────────────────────────────────────
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: AppColors.colorF3F3F6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            children: [
              GroupHeader(label: l10n.bankGroup),
              ...List.generate(state.bankMethods.length, (i) {
                final m = state.bankMethods[i];
                return BankMethodRow(
                  iconPath: m.iconPath,
                  name: m.name,
                  isLast: i == state.bankMethods.length - 1,
                  onTap: () =>
                      context.read<TopUpBloc>().add(BankMethodTapped(m.id)),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
