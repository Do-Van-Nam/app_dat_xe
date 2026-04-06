import 'package:demo_app/core/app_export.dart';

import 'bloc/order_tracking_bloc.dart';
import 'sections/delivery_address_section.dart';
import 'sections/driver_info_section.dart';
import 'sections/map_section.dart';
import 'sections/order_detail_section.dart';
import 'sections/order_status_section.dart';
import 'tracking_models.dart';

class OrderTrackingPage extends StatelessWidget {
  const OrderTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderTrackingBloc(),
      child: const _OrderTrackingView(),
    );
  }
}

class _OrderTrackingView extends StatelessWidget {
  const _OrderTrackingView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.colorF0F2F5,
      appBar: _buildAppBar(context, l10n),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Column(
                  children: const [
                    // Section 1: Order status + step bar
                    OrderStatusSection(),
                    SizedBox(height: 12),

                    // Section 2: Map
                    MapSection(),
                    SizedBox(height: 12),

                    // Section 3: Driver info
                    DriverInfoSection(),
                    SizedBox(height: 12),

                    // Section 4: Order detail
                    OrderDetailSection(),
                    SizedBox(height: 12),

                    // Section 5: Delivery address
                    DeliveryAddressSection(),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Bottom navigation bar
          ],
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
        onTap: () => context.pop(),
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Icon(Icons.arrow_back, color: AppColors.color1A1A1A, size: 22),
        ),
      ),
      title: Text(l10n.orderTracking, style: AppStyles.inter18SemiBold),
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: () =>
              context.read<OrderTrackingBloc>().add(const NotificationTapped()),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(
              AppImages.icBell,
              width: 22,
              height: 22,
              colorFilter: const ColorFilter.mode(
                AppColors.color1A1A1A,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
