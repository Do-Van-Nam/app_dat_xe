import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/generated/app_localizations.dart';
import 'package:demo_app/main/ui/food/food_bloc.dart';
import 'package:demo_app/main/ui/food/widgets/category_chip.dart';
import 'package:demo_app/main/ui/food/widgets/drink_item_card.dart';
import 'package:demo_app/main/ui/food/widgets/food_item_card.dart';

class FoodPage extends StatelessWidget {
  const FoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => FoodBloc()..add(LoadFood()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<FoodBloc, FoodState>(
            builder: (context, state) {
              final foods = state.foods.where((e) => !e.isDrink).toList();
              final drinks = state.foods.where((e) => e.isDrink).toList();

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER
                    Text(l10n.hello, style: AppStyles.title),

                    const SizedBox(height: 16),

                    /// CATEGORY
                    Row(
                      children: [
                        CategoryChip(
                          title: l10n.mainDish,
                          isActive: true,
                        ),
                        const SizedBox(width: 8),
                        CategoryChip(title: l10n.drink),
                        const SizedBox(width: 8),
                        CategoryChip(title: l10n.topping),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// FOOD LIST
                    Text(l10n.mainDish, style: AppStyles.title),
                    const SizedBox(height: 8),
                    ...foods.map(
                      (item) => FoodItemCard(
                        item: item,
                        onAdd: () {
                          context.read<FoodBloc>().add(AddToCart(item));
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// DRINK LIST
                    Text(l10n.drink, style: AppStyles.title),
                    const SizedBox(height: 8),
                    ...drinks.map(
                      (item) => DrinkItemCard(
                        item: item,
                        onAdd: () =>
                            context.read<FoodBloc>().add(AddToCart(item)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
