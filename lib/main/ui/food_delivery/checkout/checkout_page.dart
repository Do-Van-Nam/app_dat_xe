import 'package:demo_app/core/app_export.dart';

import 'bloc/checkout_bloc.dart';
import 'checkout_widgets.dart';
import 'sections/delivery_address_section.dart';
import 'sections/order_summary_section.dart';
import 'sections/payment_detail_section.dart';
import 'sections/payment_method_section.dart';
import 'sections/promo_code_section.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CheckoutBloc(),
      child: const _CheckoutView(),
    );
  }
}

class _CheckoutView extends StatelessWidget {
  const _CheckoutView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<CheckoutBloc, CheckoutState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        switch (state.status) {
          case CheckoutStatus.success:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đặt hàng thành công! 🎉')),
            );
            context.go(PATH_ORDER_TRACKING);
          case CheckoutStatus.promoApplied:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Đã áp dụng mã: ${state.promoCode}'),
                backgroundColor: AppColors.color38A169,
              ),
            );
          case CheckoutStatus.promoError:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? ''),
                backgroundColor: AppColors.colorE53E3E,
              ),
            );
          default:
            break;
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.colorF9F9FC,
        appBar: _buildAppBar(context, l10n),
        body: SafeArea(
          child: Column(
            children: [
              // ── Scrollable body ─────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      // Section 1: Delivery address
                      DeliveryAddressSection(),
                      SizedBox(height: 20),

                      // Section 2: Order summary
                      OrderSummarySection(),
                      SizedBox(height: 20),

                      // Section 3: Payment method
                      PaymentMethodSection(),
                      SizedBox(height: 20),

                      // Section 4: Promo code
                      PromoCodeSection(),
                      SizedBox(height: 20),

                      // Section 5: Payment detail
                      PaymentDetailSection(),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // ── Bottom CTA ──────────────────────────────────────────────
              _BottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, AppLocalizations l10n) {
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
      title: Text(l10n.checkout, style: AppStyles.inter18SemiBold),
      centerTitle: true,
    );
  }
}

// ── Bottom bar ─────────────────────────────────────────────────────────────
class _BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isOrdering = context.select(
      (CheckoutBloc b) => b.state.status == CheckoutStatus.ordering,
    );

    return Container(
      color: AppColors.colorFFFFFF,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: PrimaryButton(
        label: l10n.placeOrder,
        isLoading: isOrdering,
        onPressed: () =>
            context.read<CheckoutBloc>().add(const PlaceOrderTapped()),
      ),
    );
  }
}
