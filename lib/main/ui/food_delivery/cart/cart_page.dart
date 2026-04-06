import 'package:demo_app/core/app_export.dart';

import 'bloc/cart_bloc.dart';
import 'cart_widgets.dart';
import 'sections/cart_items_section.dart';
import 'sections/order_summary_section.dart';
import 'sections/promo_code_section.dart';
import 'sections/restaurant_header_section.dart';
import 'sections/restaurant_note_section.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartBloc(),
      child: const _CartView(),
    );
  }
}

class _CartView extends StatelessWidget {
  const _CartView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<CartBloc, CartState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == CartStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đặt hàng thành công!')),
          );
          context.push(PATH_CHECKOUT);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.colorWhite,
        appBar: _buildAppBar(context, l10n),
        body: SafeArea(
          child: Container(
            color: AppColors.colorF9F9FC,
            child: Column(
              children: [
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // ── Section 1: Restaurant header ──────────────────────
                        const RestaurantHeaderSection(),

                        const SizedBox(height: 8),

                        // ── Section 2: Cart items ─────────────────────────────
                        const CartItemsSection(),

                        const SizedBox(height: 8),

                        // ── Section 3: Restaurant note ────────────────────────
                        const RestaurantNoteSection(),

                        const SizedBox(height: 8),

                        // ── Section 4: Order summary ──────────────────────────
                        const OrderSummarySection(),

                        const SizedBox(height: 8),

                        // ── Section 5: Promo code ─────────────────────────────
                        const PromoCodeSection(),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                // ── Bottom CTA ────────────────────────────────────────────────
                _BottomBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return AppBar(
      backgroundColor: AppColors.colorFFFFFF,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).maybePop(),
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Icon(Icons.arrow_back, color: AppColors.color1A1A1A, size: 22),
        ),
      ),
      title: Text(l10n.cart, style: AppStyles.inter18SemiBold),
      centerTitle: true,
    );
  }
}

// ── Bottom bar with CTA ───────────────────────────────────────────────────────
class _BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      color: AppColors.colorFFFFFF,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: PrimaryButton(
        label: l10n.placeOrder,
        onPressed: () => context.read<CartBloc>().add(const PlaceOrderTapped()),
      ),
    );
  }
}
