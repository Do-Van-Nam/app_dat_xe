part of 'membership_bloc.dart';

enum MembershipStatus { initial, loading, success, registering, registered, failure }

class MembershipState extends Equatable {
  const MembershipState({
    this.status = MembershipStatus.initial,
    this.selectedPlanId = MembershipPlanId.month,
    this.plans = const [],
    this.errorMessage,
  });

  final MembershipStatus status;
  final MembershipPlanId selectedPlanId;
  final List<MembershipPlan> plans;
  final String? errorMessage;

  MembershipPlan? get selectedPlan {
    try {
      return plans.firstWhere((p) => p.id == selectedPlanId);
    } catch (_) {
      return null;
    }
  }

  MembershipState copyWith({
    MembershipStatus? status,
    MembershipPlanId? selectedPlanId,
    List<MembershipPlan>? plans,
    String? errorMessage,
  }) {
    return MembershipState(
      status: status ?? this.status,
      selectedPlanId: selectedPlanId ?? this.selectedPlanId,
      plans: plans ?? this.plans,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, selectedPlanId, plans, errorMessage];
}
