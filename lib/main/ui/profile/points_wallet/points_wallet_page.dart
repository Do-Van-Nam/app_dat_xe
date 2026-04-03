import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'points_wallet_bloc.dart';

class PointsWalletPage extends StatelessWidget {
  const PointsWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => PointsWalletBloc()..add(LoadPointsWalletEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.pointsWallet),
          leading: const BackButton(),
        ),
        body: BlocBuilder<PointsWalletBloc, PointsWalletState>(
          builder: (context, state) {
            if (state is PointsWalletLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PointsWalletError) {
              return Center(child: Text(state.message));
            }

            if (state is PointsWalletLoaded) {
              return RefreshIndicator(
                onRefresh: () async => context
                    .read<PointsWalletBloc>()
                    .add(LoadPointsWalletEvent()),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // 1. Balance Card
                      _BalanceSection(
                        points: state.totalPoints,
                        tier: state.membershipTier,
                        l10n: l10n,
                      ),

                      const SizedBox(height: 32),

                      // 2. Danh mục đổi điểm
                      Text(
                        l10n.redeemCategories,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _CategoryGrid(l10n: l10n),

                      const SizedBox(height: 32),

                      // 3. Ưu đãi dành cho bạn
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.offersForYou,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            l10n.viewAll,
                            style: const TextStyle(
                                color: AppColors.colorMain,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      ...state.redeemItems.map(
                          (item) => _RedeemItemCard(item: item, l10n: l10n)),

                      const SizedBox(height: 40),

                      // 4. Hoạt động gần đây
                      Text(
                        l10n.recentActivity,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Column(
                          children: [
                            ...state.recentActivities.map((activity) =>
                                _ActivityItem(activity: activity, l10n: l10n)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

// ==================== CÁC SECTION WIDGET DÙNG CHUNG ====================

class _BalanceSection extends StatelessWidget {
  final int points;
  final String tier;
  final AppLocalizations l10n;

  const _BalanceSection({
    required this.points,
    required this.tier,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryBlue, AppColors.colorMain],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.currentBalance,
            style: AppStyles.inter14Regular
                .copyWith(color: AppColors.colorWhite.withOpacity(0.7)),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      "${points.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} ",
                  style: AppStyles.inter28Bold.copyWith(
                    color: AppColors.colorWhite,
                    fontSize: 48,
                  ),
                ),
                TextSpan(
                  text: "Điểm",
                  style: AppStyles.inter16Bold.copyWith(
                    color: AppColors.colorYellow,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color: Colors.white.withValues(alpha: 0.20),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.colorYellow,
                  child: SvgPicture.asset(
                    AppImages.icOutlinedStar,
                    height: 12,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "HẠNG THÀNH VIÊN",
                      style: AppStyles.inter12SemiBold.copyWith(
                        color: AppColors.colorWhite,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      tier,
                      style: AppStyles.inter12SemiBold.copyWith(
                        color: AppColors.colorYellow,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.history,
                  label: l10n.pointsHistory,
                  color: AppColors.colorYellow,
                  textColor: AppColors.color_694600,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  icon: Icons.card_giftcard,
                  label: l10n.redeemCodes,
                  color: AppColors.colorWhite.withValues(alpha: 0.15),
                  textColor: AppColors.colorWhite,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  final AppLocalizations l10n;

  const _CategoryGrid({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {"icon": Icons.restaurant, "label": "Ăn uống"},
      {"icon": Icons.directions_car, "label": "Di chuyển"},
      {"icon": Icons.shopping_bag, "label": "Mua sắm"},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: categories.map((cat) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: const Color(0xFFF3F3F6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(cat["icon"] as IconData, size: 32),
              ),
              const SizedBox(height: 8),
              Text(cat["label"] as String,
                  style: const TextStyle(fontSize: 13)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _RedeemItemCard extends StatelessWidget {
  final RedeemItem item;
  final AppLocalizations l10n;

  const _RedeemItemCard({required this.item, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Image.network(
                  item.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                if (item.tag != null)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item.tag!,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.subtitle,
                            style: const TextStyle(
                                color: Colors.grey, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${item.pointsRequired} PTS",
                      style: const TextStyle(
                        color: AppColors.colorMain,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.colorMain,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      l10n.redeemNow,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final RecentActivity activity;
  final AppLocalizations l10n;

  const _ActivityItem({required this.activity, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: activity.isPositive ? Colors.green[50] : Colors.red[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          activity.isPositive ? Icons.add : Icons.card_giftcard,
          color: activity.isPositive ? Colors.green : Colors.red,
        ),
      ),
      title: Text(activity.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(activity.time),
      trailing: Text(
        "${activity.isPositive ? '+' : ''}${activity.points}",
        style: TextStyle(
          color: activity.isPositive ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
