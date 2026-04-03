import 'package:demo_app/core/app_export.dart';

import '../bloc/checkout_bloc.dart';
import '../checkout_models.dart';
import '../checkout_widgets.dart';

class PaymentDetailSection extends StatelessWidget {
  const PaymentDetailSection({super.key});

  String _fmt(int price) {
    final s = price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return '${s}đ';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<CheckoutBloc>().state;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.paymentDetail, style: AppStyles.inter16Bold),
          const SizedBox(height: 14),

          // Subtotal
          SummaryRow(
            label: l10n.subtotal,
            value: _fmt(state.subtotal),
          ),
          const SizedBox(height: 8),

          // Shipping fee
          SummaryRow(
            label: l10n.shippingFee,
            value: _fmt(state.shippingFee),
          ),
          const SizedBox(height: 8),

          // Service fee
          SummaryRow(
            label: l10n.serviceFee,
            value: _fmt(state.serviceFee),
          ),

          if (state.discount > 0) ...[
            const SizedBox(height: 8),
            SummaryRow(
              label: l10n.voucherDiscount,
              value: '-${_fmt(state.discount)}',
              labelStyle: AppStyles.inter14Medium
                  .copyWith(color: AppColors.colorED8936),
              valueStyle: AppStyles.inter14Medium
                  .copyWith(color: AppColors.colorED8936),
            ),
          ],

          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.colorDivider),
          const SizedBox(height: 14),

          // Grand total label
          Text(
            l10n.grandTotalLabel,
            style: AppStyles.inter12SemiBold.copyWith(
              color: AppColors.color999999,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),

          // Grand total value + tax note
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(_fmt(state.grandTotal), style: AppStyles.inter26ExtraBold),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  l10n.taxIncluded,
                  style: AppStyles.inter12Regular
                      .copyWith(color: AppColors.color999999),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
