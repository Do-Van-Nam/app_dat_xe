import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/ui/food/food_bloc.dart';

class FoodItemCard extends StatelessWidget {
  final FoodItem item;
  final VoidCallback onAdd;

  const FoodItemCard({
    super.key,
    required this.item,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(item.image),
      title: Text(item.title),
      subtitle: Text(item.description),
      trailing: Column(
        children: [
          Text("${item.price}đ"),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: onAdd,
          )
        ],
      ),
    );
  }
}
