import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:url_launcher/url_launcher.dart';

part 'tai_xe_nhan_event.dart';
part 'tai_xe_nhan_state.dart';

class TripDetailBloc extends Bloc<TripDetailEvent, TripDetailState> {
  TripDetailBloc() : super(const TripDetailState()) {
    on<TripDetailMoreOptionsTapped>(_onMoreOptions);
    on<TripDetailCallDriverTapped>(_onCallDriver);
    on<TripDetailMessageDriverTapped>(_onMessageDriver);
    on<TripDetailViewMapTapped>(_onViewMap);
    on<TripDetailCancelTapped>(_onCancelTapped);
    on<TripDetailCancelConfirmed>(_onCancelConfirmed);
  }

  void _onMoreOptions(
    TripDetailMoreOptionsTapped event,
    Emitter<TripDetailState> emit,
  ) {
    // TODO: show bottom sheet with options
  }

  Future<void> _onCallDriver(
    TripDetailCallDriverTapped event,
    Emitter<TripDetailState> emit,
  ) async {
    // TODO: replace with real driver phone number from repository
    const driverPhone = 'tel:+84900000000';
    final uri = Uri.parse(driverPhone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _onMessageDriver(
    TripDetailMessageDriverTapped event,
    Emitter<TripDetailState> emit,
  ) {
    // TODO: navigate to in-app chat screen
  }

  void _onViewMap(
    TripDetailViewMapTapped event,
    Emitter<TripDetailState> emit,
  ) {
    // TODO: navigate to full-screen map tracking screen
  }

  void _onCancelTapped(
    TripDetailCancelTapped event,
    Emitter<TripDetailState> emit,
  ) {
    // Cancellation confirmation is handled from the UI layer (dialog).
    // After user confirms, TripDetailCancelConfirmed is dispatched.
  }

  Future<void> _onCancelConfirmed(
    TripDetailCancelConfirmed event,
    Emitter<TripDetailState> emit,
  ) async {
    emit(state.copyWith(status: TripDetailStatus.cancelling));
    try {
      // TODO: call booking repository to cancel
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(status: TripDetailStatus.cancelled));
    } catch (e) {
      emit(state.copyWith(
        status: TripDetailStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
