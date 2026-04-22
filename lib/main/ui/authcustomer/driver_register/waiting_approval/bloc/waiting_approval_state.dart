part of 'waiting_approval_bloc.dart';

enum VerificationStepStatus { done, active, pending }

class VerificationStep extends Equatable {
  const VerificationStep({
    required this.id,
    required this.name,
    required this.subLabel,
    required this.status,
    required this.iconPath,
  });

  final String id;
  final String name;
  final String subLabel;
  final VerificationStepStatus status;
  final String iconPath;

  @override
  List<Object?> get props => [id, name, subLabel, status, iconPath];
}

enum WaitingApprovalPageStatus { waiting, approved, rejected }

class WaitingApprovalState extends Equatable {
  const WaitingApprovalState({
    this.pageStatus = WaitingApprovalPageStatus.waiting,
    this.steps = const [],
  });

  final WaitingApprovalPageStatus pageStatus;
  final List<VerificationStep> steps;

  WaitingApprovalState copyWith({
    WaitingApprovalPageStatus? pageStatus,
    List<VerificationStep>? steps,
  }) {
    return WaitingApprovalState(
      pageStatus: pageStatus ?? this.pageStatus,
      steps: steps ?? this.steps,
    );
  }

  @override
  List<Object?> get props => [pageStatus, steps];
}
