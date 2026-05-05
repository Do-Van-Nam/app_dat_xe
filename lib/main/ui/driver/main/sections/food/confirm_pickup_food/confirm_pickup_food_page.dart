import 'package:demo_app/core/app_export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/confirm_pickup_food_bloc.dart';
import 'bloc/confirm_pickup_food_event.dart';
import 'bloc/confirm_pickup_food_state.dart';
import 'confirm_pickup_food_widgets.dart';

class ConfirmPickupFoodPage extends StatelessWidget {
  const ConfirmPickupFoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConfirmPickupFoodBloc(),
      child: const ConfirmPickupFoodView(),
    );
  }
}

class ConfirmPickupFoodView extends StatelessWidget {
  const ConfirmPickupFoodView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<ConfirmPickupFoodBloc, ConfirmPickupFoodState>(
      listener: (context, state) {
        if (state.status == ConfirmPickupFoodStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Xác nhận lấy hàng thành công!")),
          );
          // Navigator.of(context).pop(); // Or route to next screen
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.colorF9F9FC,
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(
                  top: 96,
                  left: 16,
                  right: 16,
                  bottom: 128,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OrderCodeWidget(
                      label: l10n.orderCodeLabel,
                      code: '#GF-99283-VN',
                      status: l10n.pickingUpStatus,
                      restaurantName: 'Phở Thìn Lò Đúc - 13 Lò Đúc',
                    ),
                    const SizedBox(height: 24),

                    // Food Items Section
                    Text(
                      l10n.checkFoodItem,
                      style: AppStyles.inter14Bold.copyWith(
                        color: AppColors.color64748B,
                        letterSpacing: 1.40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: AppColors.colorF3F3F6,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const FoodItemWidget(
                            title: '02 Phở Bò Tái Lăn',
                            details: 'Thêm quẩy, không hành',
                            price: '140.000đ',
                          ),
                          const FoodItemWidget(
                            title: '01 Trà Đá ít trà',
                            details: '',
                            price: '5.000đ',
                          ),
                          FoodItemWidget(
                            title: '02 Quẩy Giòn',
                            details: '',
                            price: '10.000đ',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Receipt Photo Section
                    ReceiptPhotoWidget(
                      title: l10n.proofOfPickup,
                      subtitle: l10n.takePhotoReceipt,
                      requirementHint: l10n.receiptPhotoRequirement,
                      reportIssueText: l10n.reportIssue,
                      isPhotoTaken: state.isPhotoTaken,
                      onTap: () {
                        context
                            .read<ConfirmPickupFoodBloc>()
                            .add(TakeFoodPhotoEvent());
                      },
                    ),
                    const SizedBox(height: 24),

                    // Next Delivery Point Section
                    NextDeliveryPointWidget(
                      header: l10n.nextDeliveryPoint,
                      locationTitle: 'Chung cư Landmark 81',
                      locationAddress:
                          'Phòng 4205, Tầng 42, 208 Nguyễn\nHữu Cảnh, Bình Thạnh',
                      mapLabel: l10n.mapLabel,
                      callLabel: l10n.callCustomer,
                    ),
                  ],
                ),
              ),

              // Custom AppBar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.colorF9F9FC_CC,
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(Icons.arrow_back,
                                  color: AppColors.color1A1C1E),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              l10n.confirmPickupHeader,
                              style: AppStyles.inter20Bold.copyWith(
                                color: AppColors.color1A1C1E,
                                letterSpacing: -0.50,
                              ),
                            ),
                          ],
                        ),
                        // Add action icons if needed here
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Button
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 24,
                    right: 24,
                    bottom: 40,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.colorF9F9FC_E5,
                  ),
                  child: SafeArea(
                    top: false,
                    child: GestureDetector(
                      onTap: () {
                        context
                            .read<ConfirmPickupFoodBloc>()
                            .add(SubmitConfirmPickupFoodEvent());
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: ShapeDecoration(
                          gradient: LinearGradient(
                            begin: const Alignment(0.47, -0.47),
                            end: const Alignment(0.53, 1.47),
                            colors: state.isPhotoTaken
                                ? [AppColors.color00357F, AppColors.color004AAD]
                                : [
                                    AppColors.colorBDBDBD,
                                    AppColors.colorBDBDBD
                                  ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x261A1C1E),
                              blurRadius: 24,
                              offset: Offset(0, 8),
                            )
                          ],
                        ),
                        child: Center(
                          child: state.status == ConfirmPickupFoodStatus.loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : Text(
                                  l10n.confirmPickupButton,
                                  style: AppStyles.inter16SemiBold.copyWith(
                                    color: Colors.white,
                                    letterSpacing: 0.80,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
