import 'package:demo_app/core/app_export.dart';

import '../bloc/checkout_bloc.dart';
import '../checkout_models.dart';
import '../checkout_widgets.dart';

class PaymentMethodSection extends StatelessWidget {
  const PaymentMethodSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selected = context.select((CheckoutBloc b) => b.state.paymentMethod);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(l10n.paymentMethod),
        const SizedBox(height: 10),
        CommonCard(
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              RadioOptionTile<PaymentMethod>(
                value: PaymentMethod.cashOnDelivery,
                groupValue: selected,
                label: l10n.cashOnDelivery,
                iconPath: AppImages.icCashPayment,
                onChanged: (v) =>
                    context.read<CheckoutBloc>().add(PaymentMethodChanged(v)),
              ),
              const SizedBox(height: 8),
              RadioOptionTile<PaymentMethod>(
                value: PaymentMethod.bankTransfer,
                groupValue: selected,
                label: l10n.bankTransfer,
                iconPath: AppImages.icBankTransfer,
                onChanged: (v) =>
                    context.read<CheckoutBloc>().add(PaymentMethodChanged(v)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
