import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_app/core/app_export.dart';
import 'food_delivery_bloc.dart';

class FoodDeliveryPage extends StatelessWidget {
  const FoodDeliveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => FoodDeliveryBloc()..add(LoadFoodMenuEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.deliveryAndPickup, style: AppStyles.inter18Bold),
          leading: const BackButton(),
          actions: const [
            Icon(Icons.notifications_outlined),
            SizedBox(
              width: 16,
            )
          ],
        ),
        body: BlocBuilder<FoodDeliveryBloc, FoodDeliveryState>(
          builder: (context, state) {
            if (state is FoodDeliveryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is FoodDeliveryLoaded) {
              final cartCount = state.cart.values.fold(0, (a, b) => a + b);

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Image
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CachedNetworkImage(
                          imageUrl: "https://picsum.photos/id/431/600/280",
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: -48,
                          left: 8,
                          right: 8,
                          child: // Restaurant Info
                              _RestaurantInfoSection(
                                  restaurant: state.restaurant, l10n: l10n),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    // Tabs
                    _CategoryTabs(l10n: l10n),

                    // Main Dishes
                    _MenuSection(
                      isDrink: false,
                      title: l10n.mainDishes,
                      items: state.mainDishes,
                      cart: state.cart,
                      onAdd: (item) => context
                          .read<FoodDeliveryBloc>()
                          .add(AddToCartEvent(item)),
                      onRemove: (item) => context
                          .read<FoodDeliveryBloc>()
                          .add(RemoveFromCartEvent(item)),
                    ),

                    // Drinks
                    _MenuSection(
                      isDrink: true,
                      title: l10n.drinks,
                      items: state.drinks,
                      cart: state.cart,
                      onAdd: (item) => context
                          .read<FoodDeliveryBloc>()
                          .add(AddToCartEvent(item)),
                      onRemove: (item) => context
                          .read<FoodDeliveryBloc>()
                          .add(RemoveFromCartEvent(item)),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              );
            }

            return const Center(child: Text("Đã xảy ra lỗi"));
          },
        ),
        bottomSheet: BlocBuilder<FoodDeliveryBloc, FoodDeliveryState>(
          builder: (context, state) {
            if (state is FoodDeliveryLoaded && state.totalAmount > 0) {
              return _CartBottomBar(
                itemCount: state.cart.values.fold(0, (a, b) => a + b),
                totalAmount: state.totalAmount,
                l10n: l10n,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// ==================== WIDGETS DÙNG CHUNG ====================

class _RestaurantInfoSection extends StatelessWidget {
  final Restaurant restaurant;
  final AppLocalizations l10n;

  const _RestaurantInfoSection({required this.restaurant, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      // width: double.infinity,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: [
          BoxShadow(
            color: AppColors.color_1C1E.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: Offset(0, 8),
            spreadRadius: 0,
          )
        ],
      ),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(restaurant.name,
                  style: AppStyles.inter18Bold
                      .copyWith(color: AppColors.textPrimary, fontSize: 24)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: ShapeDecoration(
                  color: const Color(0xFFFDAF0A),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text("★ ${restaurant.rating}",
                    style: AppStyles.inter18Bold.copyWith(
                        color: const Color(0xFF694600), fontSize: 14)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SvgPicture.asset(AppImages.icClock2),
              const SizedBox(width: 4),
              Text("${restaurant.time}", style: AppStyles.inter14Medium),
              const SizedBox(width: 4),
              SvgPicture.asset(AppImages.icArrow),
              const SizedBox(width: 4),
              Text("${restaurant.distance}", style: AppStyles.inter14Medium),
              if (restaurant.isFreeship) ...[
                const SizedBox(width: 12),
                SvgPicture.asset(AppImages.icMoney2),
                const SizedBox(width: 4),
                Text("Freeship", style: AppStyles.inter14Medium),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  final AppLocalizations l10n;

  const _CategoryTabs({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _TabButton(label: l10n.mainDishes, isSelected: true),
          const SizedBox(width: 8),
          _TabButton(label: l10n.drinks, isSelected: false),
          const SizedBox(width: 8),
          _TabButton(label: "Topping", isSelected: false),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _TabButton({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryBlue : AppColors.color_F3F3F6,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: isSelected
            ? AppStyles.inter14Medium.copyWith(color: Colors.white)
            : AppStyles.inter14Medium,
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<MenuItem> items;
  final Map<String, int> cart;
  final Function(MenuItem) onAdd;
  final Function(MenuItem) onRemove;
  final bool isDrink;

  const _MenuSection({
    required this.title,
    required this.items,
    required this.cart,
    required this.onAdd,
    required this.onRemove,
    required this.isDrink,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(title, style: AppStyles.inter18Bold),
        ),
        ...items.map((item) => _MenuItemCard(
              isDrink: isDrink,
              item: item,
              quantity: cart[item.id] ?? 0,
              onAdd: () => onAdd(item),
              onRemove: () => onRemove(item),
            )),
      ],
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final bool isDrink;

  const _MenuItemCard({
    required this.item,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
    required this.isDrink,
  });

  @override
  Widget build(BuildContext context) {
    final formattedPrice = item.price.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');

    return Container(
      height: 110,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: 0,
          )
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            !isDrink
                ? CachedNetworkImage(
                    imageUrl: item.imageUrl,
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover)
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                          imageUrl: item.imageUrl,
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover),
                    ),
                  ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item.name,
                      style: AppStyles.inter18Bold
                          .copyWith(color: AppColors.color_1C1E, fontSize: 16)),
                  const SizedBox(height: 4),
                  if (!isDrink) ...[
                    Text(item.description,
                        style: AppStyles.inter12Regular
                            .copyWith(color: AppColors.color_666666),
                        maxLines: 2),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("$formattedPriceđ",
                          style: AppStyles.inter18Bold.copyWith(
                              color: AppColors.color_00357F, fontSize: 16)),
                      if (quantity > 0) ...[
                        Row(
                          children: [
                            IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: onRemove),
                            Text("$quantity", style: AppStyles.inter16SemiBold),
                            IconButton(
                                icon: const Icon(Icons.add), onPressed: onAdd),
                          ],
                        ),
                      ] else
                        IconButton(
                          icon: const Icon(Icons.add_circle,
                              color: AppColors.primaryBlue, size: 32),
                          onPressed: onAdd,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartBottomBar extends StatelessWidget {
  final int itemCount;
  final int totalAmount;
  final AppLocalizations l10n;

  const _CartBottomBar({
    required this.itemCount,
    required this.totalAmount,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final formatted = totalAmount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))
        ],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.colorMain,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.20),
                    child: SvgPicture.asset(AppImages.icCart,
                        width: 24, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Text("Giỏ hàng ($itemCount món)",
                      style: AppStyles.inter16Medium
                          .copyWith(color: Colors.white)),
                ],
              ),
              Text("$formattedđ",
                  style: AppStyles.inter18Bold.copyWith(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
