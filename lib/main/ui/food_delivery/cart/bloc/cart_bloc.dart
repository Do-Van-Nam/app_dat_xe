import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../cart_item.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(_initialState()) {
    on<ItemQuantityIncreased>(_onIncreased);
    on<ItemQuantityDecreased>(_onDecreased);
    on<ItemRemoved>(_onRemoved);
    on<RestaurantNoteChanged>(_onNoteChanged);
    on<PlaceOrderTapped>(_onPlaceOrder);
    on<PromoCodeTapped>(_onPromoCode);
  }

  // Seed with the items visible in the design screenshot.
  static CartState _initialState() => const CartState(
        items: [
          CartItem(
            id: '1',
            name: 'Phở Đặc Biệt',
            description: 'Tái, Nạm, Gầu, Bò viên',
            unitPrice: 75000,
            quantity: 2,
          ),
          CartItem(
            id: '2',
            name: 'Quẩy giòn',
            description: 'Giòn tan, 4 cái',
            unitPrice: 5000,
            quantity: 4,
          ),
        ],
      );

  void _onIncreased(ItemQuantityIncreased event, Emitter<CartState> emit) {
    final updated = state.items.map((item) {
      if (item.id == event.itemId) {
        return item.copyWith(quantity: item.quantity + 1);
      }
      return item;
    }).toList();
    emit(state.copyWith(items: updated));
  }

  void _onDecreased(ItemQuantityDecreased event, Emitter<CartState> emit) {
    final updated = state.items
        .map((item) {
          if (item.id == event.itemId) {
            return item.copyWith(quantity: item.quantity - 1);
          }
          return item;
        })
        .where((item) => item.quantity > 0)
        .toList();
    emit(state.copyWith(items: updated));
  }

  void _onRemoved(ItemRemoved event, Emitter<CartState> emit) {
    final updated =
        state.items.where((item) => item.id != event.itemId).toList();
    emit(state.copyWith(items: updated));
  }

  void _onNoteChanged(RestaurantNoteChanged event, Emitter<CartState> emit) {
    emit(state.copyWith(restaurantNote: event.note));
  }

  void _onPlaceOrder(PlaceOrderTapped event, Emitter<CartState> emit) {
    emit(state.copyWith(status: CartStatus.success));
  }

  void _onPromoCode(PromoCodeTapped event, Emitter<CartState> emit) {
    // Navigate to promo code screen — handled by listener in page.
  }
}
