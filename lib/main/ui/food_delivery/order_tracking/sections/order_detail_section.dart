import 'package:demo_app/core/app_export.dart';

import '../bloc/order_tracking_bloc.dart';
import '../tracking_models.dart';
import '../tracking_widgets.dart';

class OrderDetailSection extends StatelessWidget {
  const OrderDetailSection({super.key});

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
    final state = context.watch<OrderTrackingBloc>().state;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section header ────────────────────────────────────────────
          Row(
            children: [
              Text(l10n.orderDetail, style: AppStyles.inter16Bold),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.colorEBF3FF,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  state.restaurantName,
                  style: AppStyles.inter12SemiBold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Items ─────────────────────────────────────────────────────
          ...state.items.map((item) => _ItemRow(item: item, fmt: _fmt)),

          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.colorDivider),
          const SizedBox(height: 12),

          // ── Price summary ─────────────────────────────────────────────
          SummaryRow(
            label: l10n.subtotal,
            value: _fmt(state.subtotal),
          ),
          const SizedBox(height: 8),
          SummaryRow(
            label: l10n.shippingFee,
            value: _fmt(state.shippingFee),
          ),
          const SizedBox(height: 12),

          // ── Grand total ───────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.grandTotal, style: AppStyles.inter16Bold),
              Text(
                _fmt(state.grandTotal),
                style: AppStyles.inter20Bold,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item, required this.fmt});

  final TrackingOrderItem item;
  final String Function(int) fmt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Qty badge
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.colorF3F4F6,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Text(
              '${item.qty}x',
              style: AppStyles.inter12SemiBold.copyWith(
                color: AppColors.color333333,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Name + variant
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: AppStyles.inter14SemiBold),
                Text(
                  item.variant,
                  style: AppStyles.inter12Regular.copyWith(
                    color: AppColors.color999999,
                  ),
                ),
              ],
            ),
          ),

          // Price
          Text(fmt(item.price), style: AppStyles.inter14Medium),
        ],
      ),
    );
  }
}
