import 'package:demo_app/core/app_export.dart';

import '../bloc/waiting_approval_bloc.dart';

/// Single step row in the verification progress card.
/// Draws the icon circle, labels, and the vertical connector line below it.
class VerificationStepRow extends StatelessWidget {
  const VerificationStepRow({
    super.key,
    required this.step,
    required this.isLast,
  });

  final VerificationStep step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left column: circle + connector line
          SizedBox(
            width: 44,
            child: Column(
              children: [
                _StepCircle(step: step),
                if (!isLast)
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 2,
                        color: step.status == VerificationStepStatus.done
                            ? AppColors.colorStepConnectorDone
                            : AppColors.colorStepConnectorDefault,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Right column: name + sub-label
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: 2,
                bottom: isLast ? 0 : 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.name,
                    style: step.status == VerificationStepStatus.pending
                        ? AppStyles.inter14Regular.copyWith(
                            color: AppColors.colorTextGrey,
                          )
                        : AppStyles.inter14SemiBold,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    step.subLabel,
                    style: step.status == VerificationStepStatus.active
                        ? AppStyles.inter13Regular.copyWith(
                            color: AppColors.colorTextYellow,
                          )
                        : AppStyles.inter13Regular.copyWith(
                            color: step.status == VerificationStepStatus.pending
                                ? AppColors.colorTextGrey
                                : AppColors.colorTextSecondary,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({required this.step});
  final VerificationStep step;

  @override
  Widget build(BuildContext context) {
    Color circleBg;
    Color iconColor;
    Color? borderColor;

    switch (step.status) {
      case VerificationStepStatus.done:
        circleBg = AppColors.colorStepDoneCircle;
        iconColor = AppColors.colorStepDoneIcon;
        break;
      case VerificationStepStatus.active:
        circleBg = AppColors.colorStepActiveCircle;
        iconColor = AppColors.colorStepActiveIcon;
        break;
      case VerificationStepStatus.pending:
        circleBg = AppColors.colorStepPendingCircle;
        iconColor = AppColors.colorStepPendingIcon;
        borderColor = AppColors.colorStepPendingBorder;
        break;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: circleBg,
        border: borderColor != null
            ? Border.all(color: borderColor, width: 1.5)
            : null,
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        step.iconPath,
        width: 16,
        height: 16,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      ),
    );
  }
}
