import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'food_delivery_event.dart';
part 'food_delivery_state.dart';

class FoodDeliveryBloc extends Bloc<FoodDeliveryEvent, FoodDeliveryState> {
  FoodDeliveryBloc() : super(FoodDeliveryInitial()) {
    on<LoadFoodMenuEvent>(_onLoadMenu);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
  }

  Future<void> _onLoadMenu(
      LoadFoodMenuEvent event, Emitter<FoodDeliveryState> emit) async {
    emit(FoodDeliveryLoading());
    await Future.delayed(const Duration(milliseconds: 600));

    final restaurant = Restaurant(
      name: "Phở Thìn",
      rating: 4.8,
      time: "15p",
      distance: "1.2km",
      isFreeship: true,
    );

    final mainDishes = [
      MenuItem(
          id: "1",
          name: "Phở bò tái",
          description:
              "Bánh phở tươi, bò tái mềm, nước dùng xương bò hầm 24h đậm đà.",
          price: 65000,
          imageUrl: "https://picsum.photos/id/1080/300/200"),
      MenuItem(
          id: "2",
          name: "Phở bò chín",
          description: "Nạm bò giòn dai, thấm vị nước dùng truyền thống.",
          price: 65000,
          imageUrl: "https://picsum.photos/id/292/300/200"),
      MenuItem(
          id: "3",
          name: "Phở đặc biệt",
          description: "Đầy đủ tái, nạm, gầu, gân và bò viên.",
          price: 85000,
          imageUrl: "https://picsum.photos/id/431/300/200"),
    ];

    final drinks = [
      MenuItem(
          id: "d1",
          name: "Trà đá",
          description: "",
          price: 5000,
          imageUrl: "https://picsum.photos/id/201/300/200"),
      MenuItem(
          id: "d2",
          name: "Coca Cola",
          description: "",
          price: 15000,
          imageUrl: "https://picsum.photos/id/180/300/200"),
    ];

    emit(FoodDeliveryLoaded(
      restaurant: restaurant,
      mainDishes: mainDishes,
      drinks: drinks,
    ));
  }

  void _onAddToCart(AddToCartEvent event, Emitter<FoodDeliveryState> emit) {
    if (state is FoodDeliveryLoaded) {
      final current = state as FoodDeliveryLoaded;
      final newCart = Map<String, int>.from(current.cart);
      newCart[event.item.id] = (newCart[event.item.id] ?? 0) + 1;

      final newTotal = newCart.entries.fold(0, (sum, entry) {
        final item = [...current.mainDishes, ...current.drinks]
            .firstWhere((i) => i.id == entry.key);
        return sum + item.price * entry.value;
      });

      emit(current.copyWith(cart: newCart, totalAmount: newTotal));
    }
  }

  void _onRemoveFromCart(
      RemoveFromCartEvent event, Emitter<FoodDeliveryState> emit) {
    if (state is FoodDeliveryLoaded) {
      final current = state as FoodDeliveryLoaded;
      final newCart = Map<String, int>.from(current.cart);
      if (newCart.containsKey(event.item.id)) {
        newCart[event.item.id] = newCart[event.item.id]! - 1;
        if (newCart[event.item.id]! <= 0) newCart.remove(event.item.id);
      }

      final newTotal = newCart.entries.fold(0, (sum, entry) {
        final item = [...current.mainDishes, ...current.drinks]
            .firstWhere((i) => i.id == entry.key);
        return sum + item.price * entry.value;
      });

      emit(current.copyWith(cart: newCart, totalAmount: newTotal));
    }
  }
}

// Models
class Restaurant {
  final String name;
  final double rating;
  final String time;
  final String distance;
  final bool isFreeship;

  Restaurant(
      {required this.name,
      required this.rating,
      required this.time,
      required this.distance,
      required this.isFreeship});
}

class MenuItem {
  final String id;
  final String name;
  final String description;
  final int price;
  final String imageUrl;

  MenuItem(
      {required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.imageUrl});
}
