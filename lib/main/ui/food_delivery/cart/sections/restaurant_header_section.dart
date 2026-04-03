import 'package:demo_app/core/app_export.dart';

import '../bloc/cart_bloc.dart';
import '../cart_widgets.dart';

class RestaurantHeaderSection extends StatelessWidget {
  const RestaurantHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CartBloc>().state;

    return Container(
      color: AppColors.colorFFFFFF,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Restaurant icon box
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.colorRestaurantIconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppImages.icFork,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.color1A56DB,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Name + delivery label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(state.restaurantName, style: AppStyles.inter16Bold),
                const SizedBox(height: 2),
                Text(
                  state.deliveryLabel,
                  style: AppStyles.inter12Medium
                      .copyWith(color: AppColors.color999999),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
