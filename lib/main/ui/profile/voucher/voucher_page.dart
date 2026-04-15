import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/generated/app_localizations.dart';
import 'package:demo_app/main/data/model/finance/voucher.dart';
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.expiringSoon,
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
                      ...state.expiringSoon.map(
                          (v) => _ExpiringVoucherCard(voucher: v, l10n: l10n)),

                      const SizedBox(height: 32),

                      // 4. Ưu đãi của bạn
                      Text(
                        l10n.yourOffers,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: const Color(0xFFF3F3F6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
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
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  final code = codeController.text.trim();
                  if (code.isNotEmpty) {
                    context.read<VoucherBloc>().add(ApplyPromoCodeEvent(code));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.colorMain,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999)),
                ),
                child: Text(l10n.apply,
                    style: AppStyles.inter14Bold.copyWith(color: Colors.white)),
              ),
            ],
          ),
        ],
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
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999)),
              selected: isSelected,
              label: Text(tabs[index]),
              onSelected: (_) =>
                  context.read<VoucherBloc>().add(TabChangedEvent(index)),
              backgroundColor: Colors.grey[200],
              selectedColor: AppColors.colorMain,
              labelStyle: AppStyles.inter14Bold
                  .copyWith(color: isSelected ? Colors.white : Colors.black87),
            ),
          );
        }),
      ),
    );
  }
}

class _ExpiringVoucherCard extends StatelessWidget {
  final Voucher voucher;
  final AppLocalizations l10n;

  const _ExpiringVoucherCard({required this.voucher, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border:
            const Border(left: BorderSide(color: Color(0xFF805600), width: 4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: 0,
          )
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 100,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.color_FFDDB0,
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(12)),
              ),
              child: Center(
                child: Icon(
                  _getVoucherIcon(voucher.serviceType),
                  size: 50,
                  color: Colors.amber,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(voucher.serviceType ?? "Voucher",
                        style:
                            const TextStyle(fontSize: 13, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(voucher.description ?? voucher.code ?? "",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    if (voucher.validUntil != null) ...[
                      const SizedBox(height: 8),
                      Text("HSD: ${voucher.validUntil}",
                          style:
                              const TextStyle(fontSize: 13, color: Colors.red)),
                    ],
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Text(l10n.useNow,
                            style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyVoucherCard extends StatelessWidget {
  final Voucher voucher;
  final AppLocalizations l10n;

  const _MyVoucherCard({required this.voucher, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x0A1A1C1E),
              blurRadius: 16,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 48,
                height: 48,
                color: AppColors.color_D9E2FF,
                child: Icon(_getVoucherIcon(voucher.serviceType),
                    color: AppColors.colorMain),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(voucher.description ?? voucher.code ?? "",
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  if (voucher.validUntil != null)
                    Text("HSD: ${voucher.validUntil}",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(l10n.useNow),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

IconData _getVoucherIcon(String? serviceType) {
  switch (serviceType?.toLowerCase()) {
    case 'ride':
    case 'di chuyển':
      return Icons.local_taxi;
    case 'food':
    case 'ẩm thực':
      return Icons.restaurant;
    case 'delivery':
    case 'vận chuyển':
      return Icons.local_shipping;
    default:
      return Icons.confirmation_number;
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
            child: Text(
              l10n.shareNow,
              style: AppStyles.inter14Bold.copyWith(color: Colors.blue),
            ),
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
        spacing: 8,
        children: [
          SvgPicture.asset(AppImages.icOutlinedStar, width: 30, height: 30),
          Text("GÓI HỘI VIÊN PREMIUM",
              style: AppStyles.inter14Regular.copyWith(
                  color: AppColors.color_694600, fontWeight: FontWeight.bold)),
          Text(
            l10n.premiumMembershipDesc,
            style: AppStyles.inter14Regular.copyWith(
                color: AppColors.color_694600.withValues(alpha: 0.8),
                fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Xem chi tiết",
                    style: AppStyles.inter14Regular.copyWith(
                        color: AppColors.color_694600,
                        fontWeight: FontWeight.bold)),
                Icon(Icons.arrow_forward, color: Colors.white, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
