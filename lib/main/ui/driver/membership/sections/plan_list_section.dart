import 'package:demo_app/core/app_export.dart';

import '../bloc/membership_bloc.dart';
import '../membership_models.dart';
import '../membership_widgets.dart';

class PlanListSection extends StatelessWidget {
  const PlanListSection({super.key});

  String _fmt(int price) =>
      price.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]}.',
          ) +
      'đ';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<MembershipBloc>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ─────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.membershipListTitle,
              style: AppStyles.inter18Bold,
            ),
            GestureDetector(
              onTap: () => context
                  .read<MembershipBloc>()
                  .add(const BenefitDetailTapped()),
              child: Text(
                l10n.benefitDetail,
                style: AppStyles.inter13Medium.copyWith(
                  color: AppColors.color1A56DB,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // ── Packages from API ─────────────────────────────────────────
        ...state.packages.map((package) {
          final isSelected = package.id == state.selectedPackageId;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: UnselectedPlanCard(
              iconPath: AppImages.icCalendarDay, // default icon
              name: package.name ?? "Gói thành viên",
              discount: "${package.serviceFeeReductionPercent}% phí dịch vụ",
              benefit: package.description ?? "",
              price: _fmt(package.price?.toInt() ?? 0),
              isSelected: isSelected,
              onTap: () => context
                  .read<MembershipBloc>()
                  .add(PackageSelected(package.id!)),
            ),
          );
        }).toList(),
      ],
    );
  }
}

// ── Month plan card (featured / selected by default) ─────────────────────────
// class _MonthPlanCard extends StatelessWidget {
//   const _MonthPlanCard({
//     required this.plan,
//     required this.isSelected,
//     required this.fmt,
//     required this.l10n,
//   });

//   final MembershipPlan plan;
//   final bool isSelected;
//   final String Function(int) fmt;
//   final AppLocalizations l10n;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => context.read<MembershipBloc>().add(PlanSelected(plan.id)),
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [AppColors.colorPlanMonthBg, AppColors.colorPlanMonthBgEnd],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(20),
//           border: isSelected
//               ? Border.all(
//                   color: AppColors.colorFFFFFF.withOpacity(0.3), width: 2)
//               : null,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── Header row: icon + name + popular badge ────────────────
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Icon
//                 Container(
//                   width: 56,
//                   height: 56,
//                   decoration: BoxDecoration(
//                     color: AppColors.colorPlanIconBg,
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   alignment: Alignment.center,
//                   child: SvgPicture.asset(
//                     plan.iconPath,
//                     width: 28,
//                     height: 28,
//                     colorFilter: const ColorFilter.mode(
//                       AppColors.colorFFFFFF,
//                       BlendMode.srcIn,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),

//                 // Name + subtitle
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         plan.name,
//                         style: AppStyles.inter22Bold.copyWith(
//                           color: AppColors.colorFFFFFF,
//                         ),
//                       ),
//                       if (plan.subTitle != null)
//                         Text(
//                           plan.subTitle!,
//                           style: AppStyles.inter13Regular.copyWith(
//                             color: AppColors.colorFFFFFF.withOpacity(0.75),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),

//                 // Popular badge
//                 if (plan.isPopular) PopularBadge(label: l10n.planMonthBadge),
//               ],
//             ),

//             const SizedBox(height: 20),

//             // ── Benefit rows ───────────────────────────────────────────
//             ...plan.extraBenefits.map((b) => BenefitRow(text: b)).toList(),

//             const SizedBox(height: 12),

//             // ── Price row ──────────────────────────────────────────────
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   fmt(plan.price),
//                   style: AppStyles.inter28ExtraBold.copyWith(
//                     color: AppColors.colorFFFFFF,
//                   ),
//                 ),
//                 const SizedBox(width: 4),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 4),
//                   child: Text(
//                     plan.periodLabel ?? '',
//                     style: AppStyles.inter16Medium.copyWith(
//                       color: AppColors.colorFFFFFF.withOpacity(0.75),
//                     ),
//                   ),
//                 ),
//                 const Spacer(),

//                 // Selected check circle
//                 if (isSelected)
//                   Container(
//                     width: 40,
//                     height: 40,
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: AppColors.colorCheckCircle,
//                     ),
//                     alignment: Alignment.center,
//                     child: SvgPicture.asset(
//                       AppImages.icCheckFilled,
//                       width: 22,
//                       height: 22,
//                       colorFilter: const ColorFilter.mode(
//                         AppColors.colorCheckIcon,
//                         BlendMode.srcIn,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
