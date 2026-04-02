part of 'food_delivery_bloc.dart';

@immutable
sealed class FoodDeliveryState {}

final class FoodDeliveryInitial extends FoodDeliveryState {}

final class FoodDeliveryLoading extends FoodDeliveryState {}

final class FoodDeliveryLoaded extends FoodDeliveryState {
  final Restaurant restaurant;
  final List<MenuItem> mainDishes;
  final List<MenuItem> drinks;
  final Map<String, int> cart; // itemId -> quantity
  final int totalAmount;

  FoodDeliveryLoaded({
    required this.restaurant,
    required this.mainDishes,
    required this.drinks,
    this.cart = const {},
    this.totalAmount = 0,
  });

  FoodDeliveryLoaded copyWith({
    Map<String, int>? cart,
    int? totalAmount,
  }) {
    return FoodDeliveryLoaded(
      restaurant: restaurant,
      mainDishes: mainDishes,
      drinks: drinks,
      cart: cart ?? this.cart,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}
