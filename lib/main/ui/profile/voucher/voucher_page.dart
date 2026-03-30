import 'package:demo_app/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'voucher_bloc.dart';

class VoucherPage extends StatelessWidget {
  const VoucherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => VoucherBloc()..add(LoadVouchersEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.voucherDiscount),
          leading: const BackButton(),
        ),
        body: BlocConsumer<VoucherBloc, VoucherState>(
          listener: (context, state) {
            if (state is VoucherApplySuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is VoucherError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is VoucherLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is VoucherLoaded) {
              return RefreshIndicator(
                onRefresh: () async =>
                    context.read<VoucherBloc>().add(LoadVouchersEvent()),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Nhập mã khuyến mãi
                      _PromoCodeSection(l10n: l10n),

                      const SizedBox(height: 24),

                      // 2. Tab filter
                      _VoucherTabs(
                          l10n: l10n, selectedIndex: state.selectedTabIndex),

                      const SizedBox(height: 24),

                      // 3. Voucher sắp hết hạn
                      Text(
                        l10n.expiringSoon,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      ...state.expiringSoon.map(
                          (v) => _ExpiringVoucherCard(voucher: v, l10n: l10n)),

                      const SizedBox(height: 32),

                      // 4. Ưu đãi của bạn
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.yourOffers,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            l10n.endingSoon.toUpperCase(),
                            style: const TextStyle(
                                color: Colors.red, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...state.myVouchers
                          .map((v) => _MyVoucherCard(voucher: v, l10n: l10n)),

                      const SizedBox(height: 32),

                      // 5. Giới thiệu bạn bè
                      _ReferFriendBanner(l10n: l10n),

                      const SizedBox(height: 24),

                      // 6. Gói Hội Viên Premium
                      _PremiumMembershipCard(l10n: l10n),
                    ],
                  ),
                ),
              );
            }

            return const Center(child: Text("Đã xảy ra lỗi"));
          },
        ),
      ),
    );
  }
}

// ==================== CÁC WIDGET DÙNG CHUNG (Sections) ====================

class _PromoCodeSection extends StatelessWidget {
  final AppLocalizations l10n;
  const _PromoCodeSection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final TextEditingController codeController = TextEditingController();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.enterPromoCode,
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: codeController,
                    decoration: InputDecoration(
                      hintText: l10n.promoCodeExample,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    final code = codeController.text.trim();
                    if (code.isNotEmpty) {
                      context
                          .read<VoucherBloc>()
                          .add(ApplyPromoCodeEvent(code));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(l10n.apply,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _VoucherTabs extends StatelessWidget {
  final AppLocalizations l10n;
  final int selectedIndex;

  const _VoucherTabs({required this.l10n, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final tabs = [l10n.all, l10n.trip, l10n.food, "Khác"];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = index == selectedIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Text(tabs[index]),
              onSelected: (_) =>
                  context.read<VoucherBloc>().add(TabChangedEvent(index)),
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.blue,
              labelStyle:
                  TextStyle(color: isSelected ? Colors.white : Colors.black87),
            ),
          );
        }),
      ),
    );
  }
}

class _ExpiringVoucherCard extends StatelessWidget {
  final VoucherItem voucher;
  final AppLocalizations l10n;

  const _ExpiringVoucherCard({required this.voucher, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.amber[100],
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(12)),
            ),
            child: voucher.imageUrl != null
                ? ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(12)),
                    child: Image.network(voucher.imageUrl!, fit: BoxFit.cover),
                  )
                : Icon(voucher.icon, size: 50, color: Colors.amber),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(voucher.subtitle,
                      style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(voucher.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (voucher.expiry != null) ...[
                    const SizedBox(height: 8),
                    Text(voucher.expiry!, style: const TextStyle(fontSize: 13)),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: Text(l10n.useNow,
                  style: const TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class _MyVoucherCard extends StatelessWidget {
  final VoucherItem voucher;
  final AppLocalizations l10n;

  const _MyVoucherCard({required this.voucher, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[50],
          child: Icon(voucher.icon, color: Colors.blue),
        ),
        title: Text(voucher.title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle:
            Text(voucher.expiry ?? "", style: const TextStyle(fontSize: 13)),
        trailing: OutlinedButton(
          onPressed: () {},
          child: Text(l10n.useNow),
        ),
      ),
    );
  }
}

class _ReferFriendBanner extends StatelessWidget {
  final AppLocalizations l10n;

  const _ReferFriendBanner({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.referFriendTitle,
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.referFriendDesc,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
            ),
            child: Text(l10n.shareNow),
          ),
        ],
      ),
    );
  }
}

class _PremiumMembershipCard extends StatelessWidget {
  final AppLocalizations l10n;

  const _PremiumMembershipCard({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.star, color: Colors.white),
              SizedBox(width: 8),
              Text("GÓI HỘI VIÊN PREMIUM",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.premiumMembershipDesc,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {},
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Xem chi tiết",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Icon(Icons.arrow_forward, color: Colors.white, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
