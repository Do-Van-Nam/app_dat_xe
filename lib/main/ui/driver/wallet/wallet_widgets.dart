import 'package:demo_app/core/app_export.dart';

import 'bloc/wallet_models.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppCard — white rounded card with shadow
// ─────────────────────────────────────────────────────────────────────────────
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.borderRadius,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? AppColors.colorFFFFFF,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.color1A1A1A.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SosBadge
// ─────────────────────────────────────────────────────────────────────────────
class SosBadge extends StatelessWidget {
  const SosBadge({super.key, required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.colorSosBg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: AppStyles.inter13SemiBold.copyWith(
            color: AppColors.colorSosText,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TransactionTile — single row in transaction list
// ─────────────────────────────────────────────────────────────────────────────
class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.tx});
  final Transaction tx;

  @override
  Widget build(BuildContext context) {
    final isIncome = tx.isIncome;

    return AppCard(
      borderRadius: BorderRadius.circular(32),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          // Icon circle
          Container(
            width: 36,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isIncome ? AppColors.colorD4F5E2 : AppColors.colorFFEBEB,
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              isIncome ? AppImages.icArrowDown : AppImages.icArrowUp,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                isIncome ? AppColors.color27AE60 : AppColors.colorE53E3E,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Title + time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.title, style: AppStyles.inter14SemiBold),
                const SizedBox(height: 3),
                Text(tx.time, style: AppStyles.inter12Regular),
              ],
            ),
          ),

          // Amount
          Text(
            _formatAmount(tx.amount),
            style: AppStyles.inter14SemiBold.copyWith(
              color: isIncome ? AppColors.color27AE60 : AppColors.colorE53E3E,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(int amount) {
    final abs = amount.abs().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return amount >= 0 ? '+$abs' + 'đ' : '-$abs' + 'đ';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BarChart — simple vertical bar chart for performance section
// ─────────────────────────────────────────────────────────────────────────────
class SimpleBarChart extends StatelessWidget {
  const SimpleBarChart({super.key});

  static const List<double> _data = [0.55, 0.8, 0.65, 0.95, 0.4];
  static const List<Color> _colors = [
    AppColors.colorChartBar2,
    AppColors.colorChartBar1,
    AppColors.colorChartBar2,
    AppColors.colorChartBar1,
    AppColors.colorChartBar3,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 72,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(_data.length, (i) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300 + i * 80),
                decoration: BoxDecoration(
                  color: _colors[i],
                  borderRadius: BorderRadius.circular(4),
                ),
                height: 72 * _data[i],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CircleChartImage — stock chart circle (placeholder)
// ─────────────────────────────────────────────────────────────────────────────
class CircleChartImage extends StatelessWidget {
  const CircleChartImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: const DecorationImage(
          image: AssetImage('assets/images/chart_preview.jpg'),
          fit: BoxFit.cover,
        ),
        color: AppColors.colorF3F4F6,
        border: Border.all(color: AppColors.colorBorder, width: 2),
      ),
      child: const SizedBox.shrink(),
    );
  }
}
