import 'package:demo_app/core/app_export.dart';

import 'bloc/dashboard_bloc.dart';
import 'bloc/dashboard_state.dart';
import 'bloc/dashboard_event.dart';
import 'dashboard_widgets.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc(),
      child: Scaffold(
        backgroundColor: AppColors.colorF9F9FC,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          toolbarHeight: 64,
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.colorD9E2FF,
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: NetworkImage("https://placehold.co/32x32"),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Mina Shop',
                style: AppStyles.inter20Bold.copyWith(
                  color: AppColors.color1E40AF,
                  letterSpacing: -0.50,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.person, color: Colors.grey),
              onPressed: () {},
            ),
          ],
        ),
        body: const DashboardBody(),
        bottomNavigationBar: const DashboardBottomNav(),
      ),
    );
  }
}

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Settings Section
              SettingCardWidget(
                title: l10n.dashboardRestaurantStatus,
                statusText: state.isRestaurantOpen
                    ? l10n.dashboardStatusOpen
                    : l10n.dashboardStatusClosed,
                isGreenDot: state.isRestaurantOpen,
                trailing: GestureDetector(
                  onTap: () {
                    context
                        .read<DashboardBloc>()
                        .add(ToggleRestaurantStatusEvent());
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
                    decoration: ShapeDecoration(
                      color: state.isRestaurantOpen
                          ? AppColors.colorFDAF0A
                          : AppColors.color3CE36A,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                    child: Text(
                      state.isRestaurantOpen
                          ? l10n.dashboardStatusClosed
                          : l10n.dashboardStatusOpen,
                      style: AppStyles.inter14Bold.copyWith(
                        color: state.isRestaurantOpen
                            ? AppColors.color694600
                            : AppColors.color002108,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SettingCardWidget(
                title: l10n.dashboardAutoAccept,
                statusText: state.isAutoAcceptOrders
                    ? l10n.dashboardAutoAcceptOn
                    : 'Đang tắt',
                trailing: GestureDetector(
                  onTap: () {
                    context.read<DashboardBloc>().add(ToggleAutoAcceptEvent());
                  },
                  child: Container(
                    width: 56,
                    height: 32,
                    padding: const EdgeInsets.all(4),
                    decoration: ShapeDecoration(
                      color: state.isAutoAcceptOrders
                          ? AppColors.color00357F
                          : AppColors.color94A3B8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                    alignment: state.isAutoAcceptOrders
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Color(0x19000000),
                              blurRadius: 4,
                              offset: Offset(0, 2))
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Stats Section
              ProcessingOrdersWidget(
                title: l10n.dashboardProcessingOrders,
                count: '08',
                avatars: const [
                  "https://placehold.co/36x36",
                  "https://placehold.co/36x36"
                ],
                additionalCount: 6,
              ),
              const SizedBox(height: 16),
              TotalOrdersWidget(
                title: l10n.dashboardTotalOrdersToday,
                count: '42',
                comparisonText: '+12% ${l10n.dashboardComparedToYesterday}',
              ),
              const SizedBox(height: 16),
              RevenueWidget(
                title: l10n.dashboardRevenueToday,
                amount: '8.450.000đ',
                footerText: l10n.dashboardDeductedServiceFee,
              ),

              const SizedBox(height: 32),

              // New Orders Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.dashboardNewOrders,
                    style: AppStyles.inter16Bold.copyWith(
                      color: AppColors.color1A1C1E,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: ShapeDecoration(
                      color: AppColors.colorBA1A1A,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                    child: Text(
                      l10n.dashboardNewOrderLabel,
                      style: AppStyles.inter12Medium.copyWith(
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              NewOrderCardWidget(
                orderCode: '#MD-9921',
                foodItems: 'Phở Thìn Bờ Hồ x2, Quẩy x1',
                deliveryAddress: 'Giao đến: 123 Lê Lợi, Quận 1',
                price: '185.000đ',
                statusText: l10n.dashboardDriverArriving,
                statusColor: AppColors.color69FF87,
                statusTextColor: AppColors.color002108,
              ),
              const SizedBox(height: 16),
              NewOrderCardWidget(
                orderCode: '#MD-9920',
                foodItems: 'Cà phê sữa đá x4',
                deliveryAddress: 'Giao đến: Bitexco Financial Tower',
                price: '140.000đ',
                statusText: l10n.dashboardWaitingForPreparation,
                statusColor: AppColors.colorFFDDB0,
                statusTextColor: AppColors.color281800,
              ),
            ],
          ),
        );
      },
    );
  }
}

class DashboardBottomNav extends StatelessWidget {
  const DashboardBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F1A1C1E),
            blurRadius: 24,
            offset: Offset(0, -8),
          )
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(l10n.dashboardTabHome, Icons.home_filled,
                  AppColors.color1D4ED8, AppColors.colorEFF6FF),
              _buildNavItem(l10n.dashboardTabOrders, Icons.receipt_long,
                  AppColors.color94A3B8, Colors.transparent),
              _buildNavItem(l10n.dashboardTabMenu, Icons.restaurant_menu,
                  AppColors.color94A3B8, Colors.transparent),
              _buildNavItem(l10n.dashboardTabReports, Icons.bar_chart,
                  AppColors.color94A3B8, Colors.transparent),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      String label, IconData icon, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppStyles.inter10Regular.copyWith(
              color: color,
              letterSpacing: 0.50,
            ),
          ),
        ],
      ),
    );
  }
}
