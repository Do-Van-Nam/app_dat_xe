import 'package:demo_app/core/app_export.dart';

import '../bloc/order_tracking_bloc.dart';
import '../tracking_widgets.dart';

class DeliveryAddressSection extends StatelessWidget {
  const DeliveryAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final address = context.select((OrderTrackingBloc b) => b.state.address);

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.colorEBF3FF,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppImages.icLocationPin,
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                AppColors.color1A56DB,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Address info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.deliveryAddressLabel,
                  style: AppStyles.inter11Regular.copyWith(
                    color: AppColors.color1A56DB,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(address.buildingName, style: AppStyles.inter15SemiBold),
                const SizedBox(height: 2),
                Text(
                  address.detail,
                  style: AppStyles.inter13Regular,
                ),
              ],
            ),
          ),

          // Edit button
          GestureDetector(
            onTap: () => context
                .read<OrderTrackingBloc>()
                .add(const EditAddressTapped()),
            child: Text(
              l10n.editAddress,
              style: AppStyles.inter14SemiBold.copyWith(
                color: AppColors.color1A56DB,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
