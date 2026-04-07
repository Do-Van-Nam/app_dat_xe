import 'package:demo_app/core/app_export.dart';

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
          title: Text(l10n.personalInfo), // "Tìm kiếm điểm đến"
          // leading: const BackButton(),
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
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x0A000000),
                            blurRadius: 30,
                            offset: Offset(0, 8),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => context.push(PATH_EDIT_PROFILE),
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage(
                                        state.avatarUrl), // hoặc AssetImage
                                    child: state.avatarUrl.isEmpty
                                        ? const Icon(Icons.person, size: 40)
                                        : null,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: SvgPicture.asset(AppImages.icPen),
                                    ),
                                  ),
                                ],
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
                                        horizontal: 10, vertical: 2),
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFFDAF0A),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(9999),
                                      ),
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
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(context,
                                icon: AppImages.icWallet,
                                title: l10n.regularPoints, // "ĐIỂM THƯỜNG"
                                value: "${state.points} ${l10n.points}",
                                path: PATH_POINTS_WALLET),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              context,
                              icon: AppImages.icVoucher2,
                              title: l10n.vouchers,
                              value: "${state.vouchers} Voucher",
                              color: Colors.orange,
                              path: PATH_VOUCHER,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Tài khoản & Tiện ích
                    Text(
                      l10n.accountAndBenefits,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.only(
                          top: 8, left: 8, right: 8, bottom: 4),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF3F3F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildMenuItem(context, AppImages.icPerson2,
                              l10n.accountInfo, PATH_EDIT_PROFILE),
                          _buildMenuItem(context, AppImages.icBookmark,
                              l10n.savedAddresses, "() {}"),
                          _buildMenuItem(context, AppImages.icCard,
                              l10n.expenseManagement, PATH_EXPENSE_MANAGEMENT),
                          _buildMenuItem(context, AppImages.icGift,
                              l10n.voucherCode, PATH_VOUCHER),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Hỗ trợ & Ứng dụng
                    Text(
                      l10n.supportAndApp,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.only(
                          top: 8, left: 8, right: 8, bottom: 4),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF3F3F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildMenuItem(context, AppImages.icHelp,
                              l10n.helpSupport, "PATH_HELP"),
                          _buildMenuItem(context, AppImages.icSetting,
                              l10n.settings, "PATH_SETTINGS"),
                          // Đăng xuất
                          ListTile(
                            leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: SvgPicture.asset(AppImages.icLogout,
                                    colorFilter: const ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn))),
                            title: Text(
                              l10n.logout,
                              style: const TextStyle(color: Colors.red),
                            ),
                            onTap: () {
                              context.read<ProfileBloc>().add(LogoutEvent());
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

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
    required String icon,
    required String title,
    required String value,
    Color? color,
    String? path,
  }) {
    return GestureDetector(
      onTap: () => context.push(path ?? ""),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: const Color(0xFFF3F3F6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(icon),
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
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String icon,
    String title,
    String path,
  ) {
    return ListTile(
      leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: ShapeDecoration(
            color: const Color(0xFFD9E2FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: SvgPicture.asset(icon)),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.push(path ?? ""),
    );
  }
}
