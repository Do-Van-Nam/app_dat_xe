part of 'checkout_bloc.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

/// User selects a payment method.
class PaymentMethodChanged extends CheckoutEvent {
  final PaymentMethod method;
  const PaymentMethodChanged(this.method);

  @override
  List<Object?> get props => [method];
}

/// User types in the promo code input.
class PromoCodeChanged extends CheckoutEvent {
  final String code;
  const PromoCodeChanged(this.code);

  @override
  List<Object?> get props => [code];
}

/// User taps "Áp dụng" to apply the promo code.
class PromoCodeApplied extends CheckoutEvent {
  const PromoCodeApplied();
}

/// User taps "SỬA" to edit the delivery address.
class EditAddressTapped extends CheckoutEvent {
  const EditAddressTapped();
}

/// User taps "Đặt đơn ngay".
class PlaceOrderTapped extends CheckoutEvent {
  const PlaceOrderTapped();
}
