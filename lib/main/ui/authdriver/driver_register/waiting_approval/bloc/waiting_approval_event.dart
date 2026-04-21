part of 'waiting_approval_bloc.dart';

abstract class WaitingApprovalEvent extends Equatable {
  const WaitingApprovalEvent();

  @override
  List<Object?> get props => [];
}

/// Page loaded – seed steps and start polling.
class WaitingApprovalInitialised extends WaitingApprovalEvent {
  const WaitingApprovalInitialised();
}

/// Backend pushed a status update (polling / WebSocket).
class WaitingApprovalStatusUpdated extends WaitingApprovalEvent {
  const WaitingApprovalStatusUpdated(this.newStatus);
  final WaitingApprovalPageStatus newStatus;

  @override
  List<Object?> get props => [newStatus];
}

/// User taps support card → open hotline.
class WaitingApprovalSupportTapped extends WaitingApprovalEvent {
  const WaitingApprovalSupportTapped();
}

/// User taps "Quay lại trang chính".
class WaitingApprovalGoHomeTapped extends WaitingApprovalEvent {
  const WaitingApprovalGoHomeTapped();
}
