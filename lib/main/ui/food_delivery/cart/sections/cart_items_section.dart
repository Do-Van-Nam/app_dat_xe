import 'package:demo_app/core/app_export.dart';

import '../bloc/cart_bloc.dart';
import '../cart_item.dart';
import '../cart_widgets.dart';

class CartItemsSection extends StatelessWidget {
  const CartItemsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.select((CartBloc b) => b.state.items);

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: items.map((item) => _CartItemTile(item: item)).toList(),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({required this.item});

  final CartItem item;

  String _formatPrice(int price) {
    final formatted = price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return '${formatted}đ';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CommonCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      color: AppColors.colorFFFFFF,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: item.imageUrl != null
                ? Image.network(
                    item.imageUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/placeholder_food.jpg',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.colorF3F4F6,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 12),

          // Info column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(item.name, style: AppStyles.inter16Bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatPrice(item.total),
                      style: AppStyles.inter17SemiBold,
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Description
                Text(
                  item.description,
                  style: AppStyles.inter13Regular
                      .copyWith(color: AppColors.color666666),
                ),
                const SizedBox(height: 10),

                // Delete + stepper
                Row(
                  children: [
                    DeleteRow(
                      label: l10n.delete,
                      onTap: () =>
                          context.read<CartBloc>().add(ItemRemoved(item.id)),
                    ),
                    const Spacer(),
                    QuantityStepper(
                      quantity: item.quantity,
                      onDecrease: () => context
                          .read<CartBloc>()
                          .add(ItemQuantityDecreased(item.id)),
                      onIncrease: () => context
                          .read<CartBloc>()
                          .add(ItemQuantityIncreased(item.id)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
