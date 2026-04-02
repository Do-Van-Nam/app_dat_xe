part of 'food_delivery_bloc.dart';

@immutable
sealed class FoodDeliveryEvent {}

class LoadFoodMenuEvent extends FoodDeliveryEvent {}

class AddToCartEvent extends FoodDeliveryEvent {
  final MenuItem item;
  AddToCartEvent(this.item);
}

class RemoveFromCartEvent extends FoodDeliveryEvent {
  final MenuItem item;
  RemoveFromCartEvent(this.item);
}
