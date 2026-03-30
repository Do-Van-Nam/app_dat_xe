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
                    children: [
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
                                color: Colors.blue,
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
                      ...state.recentActivities.map((activity) =>
                          _ActivityItem(activity: activity, l10n: l10n)),
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
          colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
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
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            "${points.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} Điểm",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.amber,
                  child: Icon(Icons.star, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  "HẠNG THÀNH VIÊN\n$tier",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
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
                  color: Colors.amber,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  icon: Icons.card_giftcard,
                  label: l10n.redeemCodes,
                  color: Colors.white70,
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
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
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
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(cat["icon"] as IconData, size: 32),
            ),
            const SizedBox(height: 8),
            Text(cat["label"] as String, style: const TextStyle(fontSize: 13)),
          ],
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
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                Text(
                  item.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: const TextStyle(color: Colors.grey, height: 1.4),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${item.pointsRequired} PTS",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text(l10n.redeemNow),
                    ),
                  ],
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
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              activity.isPositive ? Colors.green[50] : Colors.red[50],
          child: Icon(
            activity.isPositive ? Icons.add : Icons.card_giftcard,
            color: activity.isPositive ? Colors.green : Colors.red,
          ),
        ),
        title: Text(activity.title),
        subtitle: Text(activity.time),
        trailing: Text(
          "${activity.isPositive ? '+' : ''}${activity.points}",
          style: TextStyle(
            color: activity.isPositive ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
