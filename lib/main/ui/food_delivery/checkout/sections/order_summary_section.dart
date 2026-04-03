import 'package:demo_app/core/app_export.dart';

import '../bloc/checkout_bloc.dart';
import '../checkout_models.dart';
import '../checkout_widgets.dart';

class OrderSummarySection extends StatelessWidget {
  const OrderSummarySection({super.key});

  String _formatPrice(int price) {
    final s = price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return '${s}đ';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = context.select((CheckoutBloc b) => b.state.items);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(l10n.orderSummary),
        const SizedBox(height: 10),
        Column(
          children: items
              .map((item) =>
                  _OrderItemTile(item: item, formatPrice: _formatPrice))
              .toList(),
        ),
      ],
    );
  }
}

class _OrderItemTile extends StatelessWidget {
  const _OrderItemTile({
    required this.item,
    required this.formatPrice,
  });

  final OrderItem item;
  final String Function(int) formatPrice;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.colorFFFFFF,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // Item image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: item.imageAsset != null
                ? Image.asset(
                    item.imageAsset!,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _PlaceholderImage(),
                  )
                : _PlaceholderImage(),
          ),
          const SizedBox(width: 12),

          // Name + variant + price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.displayName, style: AppStyles.inter15Bold),
                const SizedBox(height: 3),
                Text(
                  item.variant,
                  style: AppStyles.inter13Regular
                      .copyWith(color: AppColors.color999999),
                ),
                const SizedBox(height: 6),
                Text(
                  formatPrice(item.price),
                  style: AppStyles.inter15SemiBold
                      .copyWith(color: AppColors.colorF56B2A),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.colorF3F4F6,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
