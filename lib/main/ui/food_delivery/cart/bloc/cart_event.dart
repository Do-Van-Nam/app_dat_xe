part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// Increase quantity of an item by 1.
class ItemQuantityIncreased extends CartEvent {
  final String itemId;
  const ItemQuantityIncreased(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

/// Decrease quantity of an item by 1 (removes when reaching 0).
class ItemQuantityDecreased extends CartEvent {
  final String itemId;
  const ItemQuantityDecreased(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

/// Remove an item entirely from the cart.
class ItemRemoved extends CartEvent {
  final String itemId;
  const ItemRemoved(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

/// Update the restaurant note text.
class RestaurantNoteChanged extends CartEvent {
  final String note;
  const RestaurantNoteChanged(this.note);

  @override
  List<Object?> get props => [note];
}

/// User taps "Tiếp tục đặt hàng".
class PlaceOrderTapped extends CartEvent {
  const PlaceOrderTapped();
}

/// User taps "Thêm mã khuyến mãi".
class PromoCodeTapped extends CartEvent {
  const PromoCodeTapped();
}
