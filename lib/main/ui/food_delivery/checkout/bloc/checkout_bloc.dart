import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../checkout_models.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc() : super(_initial()) {
    on<PaymentMethodChanged>(_onPaymentMethodChanged);
    on<PromoCodeChanged>(_onPromoCodeChanged);
    on<PromoCodeApplied>(_onPromoCodeApplied);
    on<EditAddressTapped>(_onEditAddress);
    on<PlaceOrderTapped>(_onPlaceOrder);
  }

  static CheckoutState _initial() => const CheckoutState(
        items: [
          OrderItem(
            id: '1',
            name: 'Classic Burger',
            variant: 'Size L, Phô mai thêm',
            price: 170000,
            quantity: 2,
            imageAsset: 'assets/images/classic_burger.jpg',
          ),
          OrderItem(
            id: '2',
            name: 'Garden Salad',
            variant: 'Sốt mè rang',
            price: 85000,
            quantity: 1,
            imageAsset: 'assets/images/garden_salad.jpg',
          ),
        ],
        discount: 40000,
      );

  void _onPaymentMethodChanged(
    PaymentMethodChanged event,
    Emitter<CheckoutState> emit,
  ) {
    emit(state.copyWith(paymentMethod: event.method));
  }

  void _onPromoCodeChanged(
    PromoCodeChanged event,
    Emitter<CheckoutState> emit,
  ) {
    emit(state.copyWith(promoCodeInput: event.code));
  }

  void _onPromoCodeApplied(
    PromoCodeApplied event,
    Emitter<CheckoutState> emit,
  ) {
    final code = state.promoCodeInput.trim().toUpperCase();
    if (code.isEmpty) return;

    // Simple mock: "SAVE40" => 40,000 VND off
    if (code == 'SAVE40') {
      emit(state.copyWith(
        status: CheckoutStatus.promoApplied,
        promoCode: code,
        discount: 40000,
      ));
    } else {
      emit(state.copyWith(
        status: CheckoutStatus.promoError,
        errorMessage: 'Mã ưu đãi không hợp lệ.',
      ));
    }
  }

  void _onEditAddress(EditAddressTapped event, Emitter<CheckoutState> emit) {
    // Trigger navigation in page listener.
  }

  void _onPlaceOrder(PlaceOrderTapped event, Emitter<CheckoutState> emit) {
    emit(state.copyWith(status: CheckoutStatus.ordering));
    // Simulate a successful order.
    emit(state.copyWith(status: CheckoutStatus.success));
  }
}
