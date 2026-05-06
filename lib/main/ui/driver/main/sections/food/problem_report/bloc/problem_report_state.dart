import 'package:equatable/equatable.dart';

enum ProblemReportStatus { initial, loading, success, failure }

enum ProblemReason {
  none,
  restaurantCrowded,
  restaurantNotFound,
  cannotContactCustomer,
  customerCancelled,
  other,
}

class ProblemReportState extends Equatable {
  final ProblemReportStatus status;
  final ProblemReason selectedReason;
  final String additionalDetails;

  const ProblemReportState({
    this.status = ProblemReportStatus.initial,
    this.selectedReason = ProblemReason.none,
    this.additionalDetails = '',
  });

  ProblemReportState copyWith({
    ProblemReportStatus? status,
    ProblemReason? selectedReason,
    String? additionalDetails,
  }) {
    return ProblemReportState(
      status: status ?? this.status,
      selectedReason: selectedReason ?? this.selectedReason,
      additionalDetails: additionalDetails ?? this.additionalDetails,
    );
  }

  @override
  List<Object?> get props => [status, selectedReason, additionalDetails];
}
