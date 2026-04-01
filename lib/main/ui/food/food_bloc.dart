import 'package:flutter_bloc/flutter_bloc.dart';
part 'food_event.dart';
part 'food_state.dart';

class FoodItem {
  final String title;
  final String description;
  final int price;
  final String image;
  final bool isDrink;

  FoodItem({
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    this.isDrink = false,
  });
}

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  FoodBloc() : super(const FoodState()) {
    on<LoadFood>(_onLoadFood);
    on<AddToCart>(_onAddToCart);
  }

  void _onLoadFood(LoadFood event, Emitter<FoodState> emit) {
    final mockData = [
      FoodItem(
        title: "Phở bò tái",
        description: "Bánh phở tươi, bò tái mềm...",
        price: 65000,
        image:
            "https://media.gettyimages.com/id/1809004173/photo/natural-pineapple-on-a-tropical-background.jpg?s=612x612&w=gi&k=20&c=MD05PyDnD6-xcnSEgKCuvH8yqk2mUZ5L99PrMoI5OP0=",
      ),
      FoodItem(
        title: "Phở bò chín",
        description: "Nạm bò giòn dai...",
        price: 65000,
        image:
            "https://media.gettyimages.com/id/1809004173/photo/natural-pineapple-on-a-tropical-background.jpg?s=612x612&w=gi&k=20&c=MD05PyDnD6-xcnSEgKCuvH8yqk2mUZ5L99PrMoI5OP0=",
      ),
      FoodItem(
        title: "Trà đá",
        description: "",
        price: 5000,
        image:
            "https://media.gettyimages.com/id/1809004173/photo/natural-pineapple-on-a-tropical-background.jpg?s=612x612&w=gi&k=20&c=MD05PyDnD6-xcnSEgKCuvH8yqk2mUZ5L99PrMoI5OP0=",
        isDrink: true,
      ),
    ];

    emit(state.copyWith(foods: mockData));
  }

  void _onAddToCart(AddToCart event, Emitter<FoodState> emit) {
    final updatedCart = List<FoodItem>.from(state.cart)..add(event.item);
    emit(state.copyWith(cart: updatedCart));
  }
}
