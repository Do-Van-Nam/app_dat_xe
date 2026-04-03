import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'waiting_driver_event.dart';
part 'waiting_driver_state.dart';

class WaitingDriverBloc extends Bloc<WaitingDriverEvent, WaitingDriverState> {
  WaitingDriverBloc() : super(const WaitingDriverState()) {
    on<WaitingDriverDriverFound>(_onDriverFound);
    on<WaitingDriverSearchFailed>(_onSearchFailed);
    on<WaitingDriverMoreOptionsTapped>(_onMoreOptionsTapped);
    on<WaitingDriverCancelTapped>(_onCancelTapped);
    on<WaitingDriverCancelConfirmed>(_onCancelConfirmed);

    // Simulate driver search on init
    _startSearching();
  }

  Future<void> _startSearching() async {
    // TODO: replace with real WebSocket / polling from repository
    await Future.delayed(const Duration(seconds: 5));
    if (!isClosed) {
      add(const WaitingDriverDriverFound());
    }
  }

  void _onDriverFound(
    WaitingDriverDriverFound event,
    Emitter<WaitingDriverState> emit,
  ) {
    print("Driver found");
    emit(state.copyWith(status: WaitingDriverStatus.found));
    // TODO: navigate to driver-on-the-way screen
  }

  void _onSearchFailed(
    WaitingDriverSearchFailed event,
    Emitter<WaitingDriverState> emit,
  ) {
    emit(state.copyWith(
      status: WaitingDriverStatus.error,
      errorMessage: event.message,
    ));
  }

  void _onMoreOptionsTapped(
    WaitingDriverMoreOptionsTapped event,
    Emitter<WaitingDriverState> emit,
  ) {
    // TODO: show bottom sheet with options
  }

  void _onCancelTapped(
    WaitingDriverCancelTapped event,
    Emitter<WaitingDriverState> emit,
  ) {
    // Show confirmation dialog from the UI layer;
    // actual cancellation fires WaitingDriverCancelConfirmed.
  }

  Future<void> _onCancelConfirmed(
    WaitingDriverCancelConfirmed event,
    Emitter<WaitingDriverState> emit,
  ) async {
    emit(state.copyWith(isCancelLoading: true));
    try {
      // TODO: call cancellation repository
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(
        isCancelLoading: false,
        status: WaitingDriverStatus.cancelled,
      ));
    } catch (e) {
      emit(state.copyWith(
        isCancelLoading: false,
        status: WaitingDriverStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
