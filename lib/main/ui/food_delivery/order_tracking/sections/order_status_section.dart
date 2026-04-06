import 'package:demo_app/core/app_export.dart';

import '../bloc/order_tracking_bloc.dart';
import '../tracking_models.dart';
import '../tracking_widgets.dart';

class OrderStatusSection extends StatelessWidget {
  const OrderStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<OrderTrackingBloc>().state;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order code
          Text(
            l10n.orderCode,
            style: AppStyles.inter12SemiBold,
          ),
          const SizedBox(height: 6),

          // Status title
          Text(l10n.driverDelivering, style: AppStyles.inter22Bold),
          const SizedBox(height: 4),

          // Estimated time
          Text(
            l10n.estimatedArrival,
            style: AppStyles.inter13Regular,
          ),
          const SizedBox(height: 20),

          // Step progress
          _StepProgressBar(currentStep: state.currentStep),
        ],
      ),
    );
  }
}

// ── Step progress bar ─────────────────────────────────────────────────────────
class _StepProgressBar extends StatelessWidget {
  const _StepProgressBar({required this.currentStep});

  final OrderStep currentStep;

  static const List<_StepData> _steps = [
    _StepData(step: OrderStep.preparing, icon: AppImages.icRestaurant),
    _StepData(step: OrderStep.pickedUp, icon: AppImages.icBag),
    _StepData(step: OrderStep.delivering, icon: AppImages.icScooter),
    _StepData(step: OrderStep.completed, icon: AppImages.icHome),
  ];

  bool _isActive(OrderStep step) => step.index <= currentStep.index;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labels = [
      l10n.stepPreparing,
      l10n.stepPickedUp,
      l10n.stepDelivering,
      l10n.stepCompleted,
    ];

    return Row(
      children: List.generate(_steps.length, (i) {
        final active = _isActive(_steps[i].step);
        final isLast = i == _steps.length - 1;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    // Circle icon
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: active
                            ? AppColors.colorStepActive
                            : AppColors.colorStepInactive,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          _steps[i].icon,
                          width: 20,
                          height: 20,
                          colorFilter: ColorFilter.mode(
                            active
                                ? AppColors.colorFFFFFF
                                : AppColors.color999999,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      labels[i],
                      style: AppStyles.inter10SemiBold.copyWith(
                        color: active
                            ? AppColors.color1A56DB
                            : AppColors.color999999,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Connector line (not after last)
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 3,
                    margin: const EdgeInsets.only(bottom: 22),
                    decoration: BoxDecoration(
                      color: _isActive(_steps[i + 1].step)
                          ? AppColors.colorStepLine
                          : AppColors.colorStepInactive,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _StepData {
  const _StepData({required this.step, required this.icon});
  final OrderStep step;
  final String icon;
}
