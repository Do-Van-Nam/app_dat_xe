import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/ui/food/food_bloc.dart';

class DrinkItemCard extends StatelessWidget {
  final FoodItem item;
  final VoidCallback onAdd;
  const DrinkItemCard({
    super.key,
    required this.item,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Image.network(
              "https://media.gettyimages.com/id/1809004173/photo/natural-pineapple-on-a-tropical-background.jpg?s=612x612&w=gi&k=20&c=MD05PyDnD6-xcnSEgKCuvH8yqk2mUZ5L99PrMoI5OP0="),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: AppStyles.body),
                Text(item.price.toString(), style: AppStyles.price),
              ],
            ),
          ),
          const CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.grey,
            child: Icon(Icons.add, size: 14),
          )
        ],
      ),
    );
  }
}
