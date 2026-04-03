import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'shipping_event.dart';
part 'shipping_state.dart';

class ShippingBloc extends Bloc<ShippingEvent, ShippingState> {
  ShippingBloc() : super(const ShippingState()) {
    on<ShippingAddDeliveryPoint>(_onAddDeliveryPoint);
    on<ShippingRemoveDeliveryPoint>(_onRemoveDeliveryPoint);
    on<ShippingReturnToPickupToggled>(_onReturnToPickupToggled);
    on<ShippingServiceSelected>(_onServiceSelected);
    on<ShippingPaymentMethodTapped>(_onPaymentMethodTapped);
    on<ShippingAddInfoTapped>(_onAddInfoTapped);
    on<ShippingScheduleTapped>(_onScheduleTapped);
    on<ShippingOrderNowTapped>(_onOrderNowTapped);
  }

  void _onAddDeliveryPoint(
    ShippingAddDeliveryPoint event,
    Emitter<ShippingState> emit,
  ) {
    final updated = List<String>.from(state.deliveryPoints)..add(event.address);
    emit(state.copyWith(deliveryPoints: updated));
  }

  void _onRemoveDeliveryPoint(
    ShippingRemoveDeliveryPoint event,
    Emitter<ShippingState> emit,
  ) {
    final updated = List<String>.from(state.deliveryPoints)
      ..removeAt(event.index);
    emit(state.copyWith(deliveryPoints: updated));
  }

  void _onReturnToPickupToggled(
    ShippingReturnToPickupToggled event,
    Emitter<ShippingState> emit,
  ) {
    emit(state.copyWith(returnToPickup: !state.returnToPickup));
  }

  void _onServiceSelected(
    ShippingServiceSelected event,
    Emitter<ShippingState> emit,
  ) {
    final price =
        event.service == ShippingServiceType.sieu_toc ? '29.000đ' : '25.000đ';
    emit(state.copyWith(
      selectedService: event.service,
      totalPrice: price,
    ));
  }

  void _onPaymentMethodTapped(
    ShippingPaymentMethodTapped event,
    Emitter<ShippingState> emit,
  ) {
    // TODO: Open payment method picker and dispatch result
  }

  void _onAddInfoTapped(
    ShippingAddInfoTapped event,
    Emitter<ShippingState> emit,
  ) {
    // TODO: Navigate to order info screen
  }

  void _onScheduleTapped(
    ShippingScheduleTapped event,
    Emitter<ShippingState> emit,
  ) {
    // TODO: Navigate to schedule picker
  }

  Future<void> _onOrderNowTapped(
    ShippingOrderNowTapped event,
    Emitter<ShippingState> emit,
  ) async {
    emit(state.copyWith(status: ShippingStatus.loading));
    try {
      // TODO: Call order repository
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(status: ShippingStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: ShippingStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
