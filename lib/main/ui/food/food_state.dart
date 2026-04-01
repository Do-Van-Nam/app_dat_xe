part of 'food_bloc.dart';

class FoodState {
  final List<FoodItem> foods;
  final List<FoodItem> cart;

  const FoodState({
    this.foods = const [],
    this.cart = const [],
  });

  FoodState copyWith({
    List<FoodItem>? foods,
    List<FoodItem>? cart,
  }) {
    return FoodState(
      foods: foods ?? this.foods,
      cart: cart ?? this.cart,
    );
  }
}
