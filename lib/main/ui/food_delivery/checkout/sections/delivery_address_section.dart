import 'package:demo_app/core/app_export.dart';

import '../bloc/checkout_bloc.dart';
import '../checkout_widgets.dart';

class DeliveryAddressSection extends StatelessWidget {
  const DeliveryAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final address = context.select((CheckoutBloc b) => b.state.address);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(l10n.deliveryAddress),
        const SizedBox(height: 10),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              // ── Map placeholder ─────────────────────────────────────────
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Container(
                  height: 130,
                  color: AppColors.colorMapBg,
                  child: Center(
                    child: SvgPicture.asset(
                      AppImages.icMapMarker,
                      width: 40,
                      height: 40,
                      colorFilter: const ColorFilter.mode(
                        AppColors.color1A56DB,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),

              // ── Address details ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address.recipientName,
                            style: AppStyles.inter16Bold,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            address.fullAddress,
                            style: AppStyles.inter13Regular.copyWith(
                              color: AppColors.color666666,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => context
                          .read<CheckoutBloc>()
                          .add(const EditAddressTapped()),
                      child: Text(
                        l10n.edit,
                        style: AppStyles.inter14SemiBold.copyWith(
                          color: AppColors.color1A56DB,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
