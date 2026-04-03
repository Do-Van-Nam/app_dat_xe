part of 'cart_bloc.dart';

enum CartStatus { initial, loading, success, failure }

class CartState extends Equatable {
  const CartState({
    this.status = CartStatus.initial,
    this.items = const [],
    this.restaurantNote = '',
    this.shippingFee = 15000,
    this.restaurantName = 'Phở Gia Truyền - Lý Quốc Sư',
    this.deliveryLabel = 'GIAO HÀNG NHANH • 1.2 KM',
  });

  final CartStatus status;
  final List<CartItem> items;
  final String restaurantNote;
  final int shippingFee;
  final String restaurantName;
  final String deliveryLabel;

  int get subtotal => items.fold(0, (sum, item) => sum + item.total);
  int get grandTotal => subtotal + shippingFee;

  CartState copyWith({
    CartStatus? status,
    List<CartItem>? items,
    String? restaurantNote,
    int? shippingFee,
    String? restaurantName,
    String? deliveryLabel,
  }) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      restaurantNote: restaurantNote ?? this.restaurantNote,
      shippingFee: shippingFee ?? this.shippingFee,
      restaurantName: restaurantName ?? this.restaurantName,
      deliveryLabel: deliveryLabel ?? this.deliveryLabel,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        restaurantNote,
        shippingFee,
        restaurantName,
        deliveryLabel,
      ];
}
