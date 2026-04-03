import 'package:demo_app/core/app_export.dart';

import '../bloc/cart_bloc.dart';
import '../cart_widgets.dart';

class OrderSummarySection extends StatelessWidget {
  const OrderSummarySection({super.key});

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
    final state = context.watch<CartBloc>().state;

    return Container(
      color: AppColors.colorFFFFFF,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.total, style: AppStyles.inter16Bold),
          const SizedBox(height: 14),
          SummaryRow(
            label: l10n.subtotal,
            value: _fmt(state.subtotal),
          ),
          const SizedBox(height: 10),
          SummaryRow(
            label: l10n.shippingFee,
            value: _fmt(state.shippingFee),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.colorDivider),
          const SizedBox(height: 14),
          SummaryRow(
            label: l10n.grandTotal,
            value: _fmt(state.grandTotal),
            labelStyle: AppStyles.inter16Bold,
            valueStyle: AppStyles.inter20Bold,
          ),
        ],
      ),
    );
  }
}
