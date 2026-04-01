import 'package:demo_app/core/app_export.dart';

class FoodPage extends StatelessWidget {
  const FoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildBanner(),
              const SizedBox(height: 16),
              _buildCategory(),
              const SizedBox(height: 16),
              _buildFoodList(),
              const SizedBox(height: 16),
              _buildDrinkList(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildDrinkList() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      Text("Đồ uống", style: AppStyles.title),
      SizedBox(height: 8),
      DrinkItemCard(title: "Trà đá", price: "5.000đ"),
      DrinkItemCard(title: "Coca Cola", price: "15.000đ"),
    ],
  );
}

Widget _buildFoodList() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      Text("Món chính", style: AppStyles.title),
      SizedBox(height: 8),
      FoodItemCard(
        title: "Phở bò tái",
        description: "Bánh phở tươi, bò tái mềm...",
        price: "65.000đ",
      ),
      FoodItemCard(
        title: "Phở bò chín",
        description: "Nạm bò giòn dai...",
        price: "65.000đ",
      ),
    ],
  );
}

Widget _buildCategory() {
  return Row(
    children: const [
      CategoryChip(title: "Món chính", isActive: true),
      SizedBox(width: 8),
      CategoryChip(title: "Đồ uống"),
      SizedBox(width: 8),
      CategoryChip(title: "Topping"),
    ],
  );
}

Widget _buildBanner() {
  return Stack(
    children: [
      Image.network("https://placehold.co/390x200"),
      Positioned(
        bottom: 0,
        left: 16,
        right: 16,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Phở Thìn", style: AppStyles.title),
              const SizedBox(height: 4),
              Text("15p • 1.2km • Freeship"),
            ],
          ),
        ),
      )
    ],
  );
}

Widget _buildHeader() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        const Icon(Icons.arrow_back),
        const SizedBox(width: 12),
        Text("Giao hàng & Đưa đón", style: AppStyles.title),
      ],
    ),
  );
}

class DrinkItemCard extends StatelessWidget {
  final String title;
  final String price;

  const DrinkItemCard({
    super.key,
    required this.title,
    required this.price,
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
          Image.network("https://placehold.co/64"),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyles.body),
                Text(price, style: AppStyles.price),
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

class FoodItemCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;

  const FoodItemCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Image.network(
            "https://placehold.co/128x128",
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppStyles.title),
                  const SizedBox(height: 4),
                  Text(description, style: AppStyles.small),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(price, style: AppStyles.price),
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.primary,
                        child: Icon(Icons.add, color: Colors.white, size: 16),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String title;
  final bool isActive;

  const CategoryChip({super.key, required this.title, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.chipBg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.white : AppColors.textSecondary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
