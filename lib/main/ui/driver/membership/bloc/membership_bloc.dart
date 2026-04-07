import 'package:demo_app/core/app_export.dart';

import '../membership_models.dart';

part 'membership_event.dart';
part 'membership_state.dart';

class MembershipBloc extends Bloc<MembershipEvent, MembershipState> {
  MembershipBloc() : super(const MembershipState()) {
    on<MembershipLoaded>(_onLoaded);
    on<PlanSelected>(_onPlanSelected);
    on<BenefitDetailTapped>(_onBenefitDetail);
    on<RegisterTapped>(_onRegister);
    on<BackTapped>(_onBack);
  }

  Future<void> _onLoaded(
    MembershipLoaded event,
    Emitter<MembershipState> emit,
  ) async {
    emit(state.copyWith(status: MembershipStatus.loading));

    await Future.delayed(const Duration(milliseconds: 300));

    final plans = [
      const MembershipPlan(
        id: MembershipPlanId.day,
        name: 'Gói Ngày',
        discount: '0% chiết khấu',
        benefit: 'Ưu tiên cuốc gần',
        price: 29000,
        iconPath: AppImages.icCalendarDay,
      ),
      const MembershipPlan(
        id: MembershipPlanId.week,
        name: 'Gói Tuần',
        discount: '0% chiết khấu',
        benefit: 'Bảo hiểm tai nạn',
        price: 159000,
        iconPath: AppImages.icCalendarWeek,
      ),
      const MembershipPlan(
        id: MembershipPlanId.month,
        name: 'Gói Tháng',
        discount: '0% chiết khấu',
        benefit: 'Tất cả quyền lợi gói Tuần',
        price: 499000,
        iconPath: AppImages.icStarFilled,
        isPopular: true,
        subTitle: 'Tối ưu chi phí lâu dài',
        extraBenefits: [
          'Tất cả quyền lợi gói Tuần',
          'Thưởng KPI tháng độc quyền',
          'Ưu tiên nhận cuốc VIP',
        ],
        periodLabel: '/tháng',
      ),
    ];

    emit(state.copyWith(
      status: MembershipStatus.success,
      plans: plans,
    ));
  }

  void _onPlanSelected(PlanSelected event, Emitter<MembershipState> emit) {
    emit(state.copyWith(selectedPlanId: event.planId));
  }

  void _onBenefitDetail(
      BenefitDetailTapped event, Emitter<MembershipState> emit) {
    // Navigate to benefit detail screen from page listener.
  }

  Future<void> _onRegister(
    RegisterTapped event,
    Emitter<MembershipState> emit,
  ) async {
    emit(state.copyWith(status: MembershipStatus.registering));
    await Future.delayed(const Duration(milliseconds: 800));
    emit(state.copyWith(status: MembershipStatus.registered));
  }

  void _onBack(BackTapped event, Emitter<MembershipState> emit) {
    // Handled by page (Navigator.pop).
  }
}
