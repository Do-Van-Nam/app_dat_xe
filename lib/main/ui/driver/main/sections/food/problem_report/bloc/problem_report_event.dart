import 'package:equatable/equatable.dart';
import 'problem_report_state.dart';

abstract class ProblemReportEvent extends Equatable {
  const ProblemReportEvent();

  @override
  List<Object?> get props => [];
}

class SelectReasonEvent extends ProblemReportEvent {
  final ProblemReason reason;

  const SelectReasonEvent(this.reason);

  @override
  List<Object?> get props => [reason];
}

class UpdateAdditionalDetailsEvent extends ProblemReportEvent {
  final String details;

  const UpdateAdditionalDetailsEvent(this.details);

  @override
  List<Object?> get props => [details];
}

class SubmitReportEvent extends ProblemReportEvent {}
