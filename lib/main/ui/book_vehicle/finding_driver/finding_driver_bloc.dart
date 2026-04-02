import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'finding_driver_event.dart';
part 'finding_driver_state.dart';

class FindingDriverBloc extends Bloc<FindingDriverEvent, FindingDriverState> {
  FindingDriverBloc() : super(const FindingDriverState()) {
    on<FindingDriverStartSearch>(_onStartSearch);
    on<FindingDriverCancelSearch>(_onCancelSearch);
    on<FindingDriverFound>(_onDriverFound);
    on<FindingDriverTimeout>(_onTimeout);
  }

  Future<void> _onStartSearch(
    FindingDriverStartSearch event,
    Emitter<FindingDriverState> emit,
  ) async {
    emit(state.copyWith(status: FindingDriverStatus.searching));

    // Simulate searching for a driver
    await Future.delayed(const Duration(seconds: 8));

    // Only emit if still searching (not cancelled)
    if (state.status == FindingDriverStatus.searching) {
      add(const FindingDriverFound());
    }
  }

  void _onCancelSearch(
    FindingDriverCancelSearch event,
    Emitter<FindingDriverState> emit,
  ) {
    emit(state.copyWith(status: FindingDriverStatus.cancelled));
  }

  void _onDriverFound(
    FindingDriverFound event,
    Emitter<FindingDriverState> emit,
  ) {
    emit(state.copyWith(status: FindingDriverStatus.found));
  }

  void _onTimeout(
    FindingDriverTimeout event,
    Emitter<FindingDriverState> emit,
  ) {
    emit(state.copyWith(status: FindingDriverStatus.timeout));
  }
}
