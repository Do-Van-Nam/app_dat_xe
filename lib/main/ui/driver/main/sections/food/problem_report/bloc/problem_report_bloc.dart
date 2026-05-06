import 'package:bloc/bloc.dart';
import 'problem_report_event.dart';
import 'problem_report_state.dart';

class ProblemReportBloc extends Bloc<ProblemReportEvent, ProblemReportState> {
  ProblemReportBloc() : super(const ProblemReportState()) {
    on<SelectReasonEvent>(_onSelectReason);
    on<UpdateAdditionalDetailsEvent>(_onUpdateAdditionalDetails);
    on<SubmitReportEvent>(_onSubmitReport);
  }

  void _onSelectReason(SelectReasonEvent event, Emitter<ProblemReportState> emit) {
    emit(state.copyWith(selectedReason: event.reason));
  }

  void _onUpdateAdditionalDetails(UpdateAdditionalDetailsEvent event, Emitter<ProblemReportState> emit) {
    emit(state.copyWith(additionalDetails: event.details));
  }

  Future<void> _onSubmitReport(SubmitReportEvent event, Emitter<ProblemReportState> emit) async {
    if (state.selectedReason == ProblemReason.none) return;
    
    emit(state.copyWith(status: ProblemReportStatus.loading));
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    emit(state.copyWith(status: ProblemReportStatus.success));
  }
}
