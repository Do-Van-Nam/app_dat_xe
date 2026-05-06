import 'package:demo_app/core/app_export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/problem_report_bloc.dart';
import 'bloc/problem_report_event.dart';
import 'bloc/problem_report_state.dart';
import 'problem_report_widgets.dart';

class ProblemReportPage extends StatelessWidget {
  const ProblemReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProblemReportBloc(),
      child: const ProblemReportView(),
    );
  }
}

class ProblemReportView extends StatelessWidget {
  const ProblemReportView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<ProblemReportBloc, ProblemReportState>(
      listener: (context, state) {
        if (state.status == ProblemReportStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Báo cáo thành công!")),
          );
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.colorF9F9FC,
          appBar: AppBar(
            backgroundColor: AppColors.colorF8FAFC_CC,
            surfaceTintColor: Colors.transparent,
            elevation: 1,
            shadowColor: const Color(0x0C000000),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.color1E3A8A),
              onPressed: () => Navigator.of(context).pop(),
            ),
            titleSpacing: 0,
            title: Text(
              l10n.reportIssueTitle,
              style: AppStyles.inter18Bold.copyWith(
                color: AppColors.color1E3A8A,
                letterSpacing: -0.45,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 24,
                left: 16,
                right: 16,
                bottom: 128,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Text
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: l10n.youAreFacing,
                          style: AppStyles.inter28Bold.copyWith(
                            color: AppColors.color1A1C1E,
                            letterSpacing: -1.50,
                          ),
                        ),
                        TextSpan(
                          text: l10n.whatProblem,
                          style: AppStyles.inter28Bold.copyWith(
                            color: AppColors.color00357F,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.problemReasonInstruction,
                    style: AppStyles.inter16Regular.copyWith(
                      color: AppColors.color434653,
                      height: 1.50,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Reason Selection List
                  ReasonItemWidget(
                    icon: AppImages.icClock3,
                    label: l10n.restaurantCrowded,
                    isSelected:
                        state.selectedReason == ProblemReason.restaurantCrowded,
                    onTap: () {
                      context.read<ProblemReportBloc>().add(
                          const SelectReasonEvent(
                              ProblemReason.restaurantCrowded));
                    },
                  ),
                  const SizedBox(height: 12),
                  ReasonItemWidget(
                    icon: AppImages.icLocationError,
                    label: l10n.restaurantNotFound,
                    isSelected: state.selectedReason ==
                        ProblemReason.restaurantNotFound,
                    onTap: () {
                      context.read<ProblemReportBloc>().add(
                          const SelectReasonEvent(
                              ProblemReason.restaurantNotFound));
                    },
                  ),
                  const SizedBox(height: 12),
                  ReasonItemWidget(
                    icon: AppImages.icUnableToContact,
                    label: l10n.cannotContactCustomer,
                    isSelected: state.selectedReason ==
                        ProblemReason.cannotContactCustomer,
                    onTap: () {
                      context.read<ProblemReportBloc>().add(
                          const SelectReasonEvent(
                              ProblemReason.cannotContactCustomer));
                    },
                  ),
                  const SizedBox(height: 12),
                  ReasonItemWidget(
                    icon: AppImages.icCircleX,
                    label: l10n.customerCancelled,
                    isSelected:
                        state.selectedReason == ProblemReason.customerCancelled,
                    onTap: () {
                      context.read<ProblemReportBloc>().add(
                          const SelectReasonEvent(
                              ProblemReason.customerCancelled));
                    },
                  ),
                  const SizedBox(height: 12),
                  ReasonItemWidget(
                    icon: AppImages.icMore2,
                    label: l10n.otherReason,
                    isSelected: state.selectedReason == ProblemReason.other,
                    onTap: () {
                      context
                          .read<ProblemReportBloc>()
                          .add(const SelectReasonEvent(ProblemReason.other));
                    },
                  ),
                  const SizedBox(height: 16),

                  // Additional Details TextField
                  AdditionalDetailsWidget(
                    title: l10n.additionalDetailsOptional,
                    hintText: l10n.additionalDetailsHint,
                    onChanged: (val) {
                      context
                          .read<ProblemReportBloc>()
                          .add(UpdateAdditionalDetailsEvent(val));
                    },
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons
                  GestureDetector(
                    onTap: () {
                      context
                          .read<ProblemReportBloc>()
                          .add(SubmitReportEvent());
                    },
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: const Alignment(0.48, -0.48),
                          end: const Alignment(0.52, 1.48),
                          colors: state.selectedReason != ProblemReason.none
                              ? [AppColors.colorFDAF0A, AppColors.colorFFBA45]
                              : [AppColors.colorBDBDBD, AppColors.colorBDBDBD],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: AppColors.colorFDAF0A_33,
                            blurRadius: 15,
                            offset: Offset(0, 10),
                          )
                        ],
                      ),
                      child: Center(
                        child: state.status == ProblemReportStatus.loading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                l10n.sendReport,
                                style: AppStyles.inter16Bold.copyWith(
                                  color:
                                      state.selectedReason != ProblemReason.none
                                          ? AppColors.color694600
                                          : Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: ShapeDecoration(
                        color: AppColors.colorF3F3F6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          l10n.goBack,
                          style: AppStyles.inter16Bold.copyWith(
                            color: AppColors.color434653,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
