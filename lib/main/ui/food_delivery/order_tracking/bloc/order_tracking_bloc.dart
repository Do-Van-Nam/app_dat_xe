import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../tracking_models.dart';

part 'order_tracking_event.dart';
part 'order_tracking_state.dart';

class OrderTrackingBloc extends Bloc<OrderTrackingEvent, OrderTrackingState> {
  OrderTrackingBloc() : super(const OrderTrackingState()) {
    on<OrderStepAdvanced>(_onStepAdvanced);
    on<NotificationTapped>(_onNotification);
    on<CallDriverTapped>(_onCallDriver);
    on<ChatDriverTapped>(_onChatDriver);
    on<EditAddressTapped>(_onEditAddress);
    on<NavTabChanged>(_onNavTabChanged);
    on<RecenterMapTapped>(_onRecenterMap);
  }

  void _onStepAdvanced(
    OrderStepAdvanced event,
    Emitter<OrderTrackingState> emit,
  ) {
    final next = _nextStep(state.currentStep);
    if (next != null) {
      emit(state.copyWith(currentStep: next));
    }
  }

  OrderStep? _nextStep(OrderStep current) {
    switch (current) {
      case OrderStep.preparing:
        return OrderStep.pickedUp;
      case OrderStep.pickedUp:
        return OrderStep.delivering;
      case OrderStep.delivering:
        return OrderStep.completed;
      case OrderStep.completed:
        return null;
    }
  }

  void _onNotification(
    NotificationTapped event,
    Emitter<OrderTrackingState> emit,
  ) {
    // Handle notification navigation in page.
  }

  void _onCallDriver(
    CallDriverTapped event,
    Emitter<OrderTrackingState> emit,
  ) {
    // Launch phone dialer via url_launcher in page listener.
  }

  void _onChatDriver(
    ChatDriverTapped event,
    Emitter<OrderTrackingState> emit,
  ) {
    // Navigate to chat screen.
  }

  void _onEditAddress(
    EditAddressTapped event,
    Emitter<OrderTrackingState> emit,
  ) {
    // Navigate to edit address screen.
  }

  void _onNavTabChanged(
    NavTabChanged event,
    Emitter<OrderTrackingState> emit,
  ) {
    emit(state.copyWith(selectedTab: event.tab));
  }

  void _onRecenterMap(
    RecenterMapTapped event,
    Emitter<OrderTrackingState> emit,
  ) {
    // Trigger map controller recenter in page.
  }
}
