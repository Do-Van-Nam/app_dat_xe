import 'package:demo_app/generated/app_localizations.dart';
import 'package:demo_app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => ProfileBloc()..add(LoadProfileEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.searchDestination), // "Tìm kiếm điểm đến"
          leading: const BackButton(),
          actions: const [
            IconButton(
              icon: Icon(Icons.notifications_outlined),
              onPressed: null, // TODO: xử lý thông báo
            ),
          ],
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileError) {
              return Center(child: Text(state.message));
            }

            if (state is ProfileLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header user
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => context.push(PATH_EDIT_PROFILE),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    state.avatarUrl), // hoặc AssetImage
                                child: state.avatarUrl.isEmpty
                                    ? const Icon(Icons.person, size: 40)
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(state.phone),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      state.membership,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Điểm & Voucher
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(context,
                              icon: Icons.stars,
                              title: l10n.regularPoints, // "ĐIỂM THƯỜNG"
                              value: "${state.points} ${l10n.points}",
                              path: PATH_POINTS_WALLET),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            icon: Icons.local_offer,
                            title: l10n.vouchers,
                            value: "${state.vouchers} Voucher",
                            color: Colors.orange,
                            path: PATH_VOUCHER,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Tài khoản & Tiện ích
                    Text(
                      l10n.accountAndBenefits,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    _buildMenuItem(context, Icons.person, l10n.accountInfo,
                        PATH_EDIT_PROFILE),
                    _buildMenuItem(
                        context, Icons.bookmark, l10n.savedAddresses, "() {}"),
                    _buildMenuItem(context, Icons.receipt_long,
                        l10n.expenseManagement, PATH_EXPENSE_MANAGEMENT),
                    _buildMenuItem(context, Icons.card_giftcard,
                        l10n.voucherCode, PATH_VOUCHER),

                    const SizedBox(height: 32),

                    // Hỗ trợ & Ứng dụng
                    Text(
                      l10n.supportAndApp,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    _buildMenuItem(context, Icons.help_outline,
                        l10n.helpSupport, "PATH_HELP"),
                    _buildMenuItem(context, Icons.settings, l10n.settings,
                        "PATH_SETTINGS"),

                    const SizedBox(height: 24),

                    // Đăng xuất
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: Text(
                        l10n.logout,
                        style: const TextStyle(color: Colors.red),
                      ),
                      onTap: () {
                        context.read<ProfileBloc>().add(LogoutEvent());
                      },
                    ),

                    const SizedBox(height: 40),
                    Center(
                      child: Text(
                        "PHIÊN BẢN 4.21.0",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text("Không có dữ liệu"));
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    Color? color,
    String? path,
  }) {
    return GestureDetector(
      onTap: () => context.push(path ?? ""),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon,
                  size: 32, color: color ?? Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(title, style: Theme.of(context).textTheme.bodyMedium),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    String path,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push(path ?? ""),
      ),
    );
  }
}
