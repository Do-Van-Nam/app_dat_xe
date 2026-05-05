import 'package:demo_app/core/app_export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/confirm_pickup_bloc.dart';
import 'bloc/confirm_pickup_event.dart';
import 'bloc/confirm_pickup_state.dart';
import 'confirm_pickup_widgets.dart';

class ConfirmPickupPage extends StatelessWidget {
  const ConfirmPickupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConfirmPickupBloc(),
      child: const ConfirmPickupView(),
    );
  }
}

class ConfirmPickupView extends StatelessWidget {
  const ConfirmPickupView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<ConfirmPickupBloc, ConfirmPickupState>(
      listener: (context, state) {
        if (state.status == ConfirmPickupStatus.success) {
          // Navigate or show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Xác nhận lấy hàng thành công!")),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.colorF9F9FC,
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(
                  top: 80,
                  left: 16,
                  right: 16,
                  bottom: 128,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Section
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: ShapeDecoration(
                        color: AppColors.colorF3F3F6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TrackingCodeWidget(
                            label: l10n.trackingCode,
                            code: '#NX-8829-01',
                            status: l10n.statusProcessing,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: InfoCardWidget(
                                  icon: AppImages.icBag2,
                                  label: l10n.weight,
                                  value: '2.0 kg',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: InfoCardWidget(
                                  icon: AppImages.icComputer,
                                  label: l10n.itemType,
                                  value: 'Đồ điện tử',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ImageProofWidget(
                            title: l10n.imageProof,
                            subtitle: l10n.takePhotoPackage,
                            hint: l10n.photoRequirement,
                            isPhotoTaken: state.isPhotoTaken,
                            onTap: () {
                              context
                                  .read<ConfirmPickupBloc>()
                                  .add(ConfirmPickupCameraTapped());
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Checklist Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: ShapeDecoration(
                        color: AppColors.colorF3F3F6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              l10n.checklist,
                              style: AppStyles.inter14Bold.copyWith(
                                color: AppColors.color1A1C1E,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ChecklistItemWidget(
                            title: l10n.checkedItem,
                            isChecked: state.isPackageChecked,
                            onTap: () {
                              context
                                  .read<ConfirmPickupBloc>()
                                  .add(TogglePackageCheckedEvent());
                            },
                          ),
                          const SizedBox(height: 12),
                          ChecklistItemWidget(
                            title: l10n.takenPhoto,
                            isChecked: state.isPhotoTaken,
                            onTap: () {
                              context
                                  .read<ConfirmPickupBloc>()
                                  .add(TakePhotoEvent());
                            },
                          ),
                          const SizedBox(height: 16),
                          SenderInfoWidget(
                            label: l10n.sender,
                            name: 'Cửa hàng Điện máy Nexus',
                            address: 'Quận 1, TP. Hồ Chí Minh',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Custom App Bar Area
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0C000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.arrow_back,
                              color: AppColors.color0F172A),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n.confirmPickupHeader,
                        style: AppStyles.inter18Bold.copyWith(
                          color: AppColors.color0F172A,
                          letterSpacing: -0.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Button Area
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(32)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 32,
                        offset: Offset(0, -8),
                      )
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: GestureDetector(
                      onTap: () {
                        context
                            .read<ConfirmPickupBloc>()
                            .add(SubmitConfirmPickupEvent());
                      },
                      child: Container(
                        height: 64,
                        decoration: ShapeDecoration(
                          color: (state.isPackageChecked && state.isPhotoTaken)
                              ? AppColors.colorF9AB00
                              : AppColors.colorBDBDBD,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        child: Center(
                          child: state.status == ConfirmPickupStatus.loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : Text(
                                  l10n.confirmPickupButton,
                                  style: AppStyles.inter13Regular.copyWith(
                                    color: Colors.white,
                                    letterSpacing: -0.45,
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
