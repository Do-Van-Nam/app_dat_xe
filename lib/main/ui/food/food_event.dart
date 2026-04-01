part of 'food_bloc.dart';

abstract class FoodEvent {}

class LoadFood extends FoodEvent {}

class AddToCart extends FoodEvent {
  final FoodItem item;

  AddToCart(this.item);
}
