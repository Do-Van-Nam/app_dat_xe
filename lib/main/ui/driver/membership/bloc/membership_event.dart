part of 'membership_bloc.dart';

abstract class MembershipEvent extends Equatable {
  const MembershipEvent();
  @override
  List<Object?> get props => [];
}

/// Page initializes — load plan list.
class MembershipLoaded extends MembershipEvent {
  const MembershipLoaded();
}

class PackageSelected extends MembershipEvent {
  final String packageId;
  const PackageSelected(this.packageId);
  @override
  List<Object?> get props => [packageId];
}

/// User taps "Chi tiết quyền lợi".
class BenefitDetailTapped extends MembershipEvent {
  const BenefitDetailTapped();
}

/// User taps "Đăng ký ngay".
class RegisterTapped extends MembershipEvent {
  const RegisterTapped();
}

/// User taps back.
class BackTapped extends MembershipEvent {
  const BackTapped();
}
