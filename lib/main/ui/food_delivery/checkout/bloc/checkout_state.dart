part of 'checkout_bloc.dart';

enum CheckoutStatus { initial, applyingPromo, promoApplied, promoError, ordering, success, failure }

class CheckoutState extends Equatable {
  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.address = const DeliveryAddress(
      recipientName: 'Alex Morgan',
      fullAddress: '123 Đường Lê Lợi, Phường Bến Thành,\nQuận 1, TP. Hồ Chí Minh',
    ),
    this.items = const [],
    this.paymentMethod = PaymentMethod.bankTransfer,
    this.promoCode = '',
    this.promoCodeInput = '',
    this.discount = 0,
    this.shippingFee = 15000,
    this.serviceFee = 5000,
    this.errorMessage,
  });

  final CheckoutStatus status;
  final DeliveryAddress address;
  final List<OrderItem> items;
  final PaymentMethod paymentMethod;
  final String promoCode;
  final String promoCodeInput;
  final int discount;
  final int shippingFee;
  final int serviceFee;
  final String? errorMessage;

  int get subtotal => items.fold(0, (sum, item) => sum + item.price);
  int get grandTotal => subtotal + shippingFee + serviceFee - discount;

  CheckoutState copyWith({
    CheckoutStatus? status,
    DeliveryAddress? address,
    List<OrderItem>? items,
    PaymentMethod? paymentMethod,
    String? promoCode,
    String? promoCodeInput,
    int? discount,
    int? shippingFee,
    int? serviceFee,
    String? errorMessage,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      address: address ?? this.address,
      items: items ?? this.items,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      promoCode: promoCode ?? this.promoCode,
      promoCodeInput: promoCodeInput ?? this.promoCodeInput,
      discount: discount ?? this.discount,
      shippingFee: shippingFee ?? this.shippingFee,
      serviceFee: serviceFee ?? this.serviceFee,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        address,
        items,
        paymentMethod,
        promoCode,
        promoCodeInput,
        discount,
        shippingFee,
        serviceFee,
        errorMessage,
      ];
}
