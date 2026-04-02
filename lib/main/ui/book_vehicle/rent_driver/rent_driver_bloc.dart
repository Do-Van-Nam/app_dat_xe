import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'rent_driver_event.dart';
part 'rent_driver_state.dart';

class RentDriverBloc extends Bloc<RentDriverEvent, RentDriverState> {
  RentDriverBloc() : super(const RentDriverState()) {
    on<RentDriverLocationDetected>(_onLocationDetected);
    on<RentDriverLocationFailed>(_onLocationFailed);
    on<RentDriverDestinationChanged>(_onDestinationChanged);
    on<RentDriverSuggestionTapped>(_onSuggestionTapped);
    on<RentDriverDestinationRowTapped>(_onDestinationRowTapped);
    on<RentDriverContinueTapped>(_onContinueTapped);
    on<RentDriverPromoTapped>(_onPromoTapped);

    // Simulate auto-location on init
    _simulateLocating();
  }

  Future<void> _simulateLocating() async {
    await Future.delayed(const Duration(seconds: 2));
    add(const RentDriverLocationDetected(
      pickupName: 'Vinhomes Central ...',
      pickupAddress: '208 Nguyễn Hữu Cảnh, Ph...',
    ));
  }

  void _onLocationDetected(
    RentDriverLocationDetected event,
    Emitter<RentDriverState> emit,
  ) {
    emit(state.copyWith(
      locationStatus: RentDriverLocationStatus.located,
      pickupName: event.pickupName,
      pickupAddress: event.pickupAddress,
    ));
  }

  void _onLocationFailed(
    RentDriverLocationFailed event,
    Emitter<RentDriverState> emit,
  ) {
    emit(state.copyWith(
      locationStatus: RentDriverLocationStatus.error,
      errorMessage: event.message,
    ));
  }

  void _onDestinationChanged(
    RentDriverDestinationChanged event,
    Emitter<RentDriverState> emit,
  ) {
    emit(state.copyWith(destination: event.destination));
  }

  void _onSuggestionTapped(
    RentDriverSuggestionTapped event,
    Emitter<RentDriverState> emit,
  ) {
    emit(state.copyWith(destination: event.suggestion));
  }

  void _onDestinationRowTapped(
    RentDriverDestinationRowTapped event,
    Emitter<RentDriverState> emit,
  ) {
    // TODO: navigate to destination search screen, then dispatch RentDriverDestinationChanged
  }

  Future<void> _onContinueTapped(
    RentDriverContinueTapped event,
    Emitter<RentDriverState> emit,
  ) async {
    if (!state.canContinue) return;
    emit(state.copyWith(isLoading: true));
    try {
      // TODO: Call booking repository / price estimation API
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(
        isLoading: false,
        currentStep: RentDriverStep.confirm,
        estimatedPrice: '150.000đ',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onPromoTapped(
    RentDriverPromoTapped event,
    Emitter<RentDriverState> emit,
  ) {
    // TODO: navigate to voucher / promo screen
  }
}
