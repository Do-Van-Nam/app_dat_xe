import 'package:demo_app/core/app_export.dart';

import 'bloc/orders_bloc.dart';
import 'bloc/orders_state.dart';
import 'bloc/orders_event.dart';
import 'orders_widgets.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersBloc(),
      child: Scaffold(
        backgroundColor: AppColors.colorF9F9FC,
        appBar: AppBar(
          backgroundColor: Colors.white.withOpacity(0.8),
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
                  borderRadius: BorderRadius.circular(9999),
                  image: const DecorationImage(
                    image: NetworkImage("https://placehold.co/40x40"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.dashboardTabOrders,
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
        body: const OrdersBody1(),
      ),
    );
  }
}

class OrdersBody extends StatelessWidget {
  const OrdersBody({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              // Stats Section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: OrderStatCard(
                            title: l10n.ordersTotalOrders,
                            value: state.totalOrders.toString(),
                            bgColor: AppColors.colorF3F3F6,
                            textColor: AppColors.color1A1C1E,
                            labelColor: AppColors.color737784,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OrderStatCard(
                            title: l10n.ordersRevenue,
                            value: state.revenue,
                            bgColor: AppColors.colorFDAF0A,
                            textColor: AppColors.color694600,
                            labelColor: AppColors.color694600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    OrderStatCard(
                      title: l10n.ordersPerformance,
                      value:
                          '${l10n.ordersPerformanceGood} (${(state.performance * 100).toInt()}%)',
                      bgColor: AppColors.color004AAD,
                      textColor: Colors.white,
                      labelColor: AppColors.colorA9C1FF,
                      trailing: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child:
                            const Icon(Icons.trending_up, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Tabs Section
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    OrderTabItem(
                      label: l10n.ordersTabNew,
                      count: '4',
                      isActive: state.activeTab == OrderTab.newOrder,
                      onTap: () => context
                          .read<OrdersBloc>()
                          .add(const TabChangedEvent(OrderTab.newOrder)),
                    ),
                    const SizedBox(width: 8),
                    OrderTabItem(
                      label: l10n.ordersTabPreparing,
                      isActive: state.activeTab == OrderTab.preparing,
                      onTap: () => context
                          .read<OrdersBloc>()
                          .add(const TabChangedEvent(OrderTab.preparing)),
                    ),
                    const SizedBox(width: 8),
                    OrderTabItem(
                      label: l10n.ordersTabDone,
                      isActive: state.activeTab == OrderTab.done,
                      onTap: () => context
                          .read<OrdersBloc>()
                          .add(const TabChangedEvent(OrderTab.done)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Orders List
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 600),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  children: [
                    OrderItemCard(
                      orderCode: '#GF-88291',
                      timeAgo: l10n.ordersMinutesAgo(2),
                      items:
                          '2x Phở Bò Tái Lăn, 1x Trà Đào Cam Sả, 1x Gỏi Cuốn Tôm Thịt',
                      avatars: const [
                        "https://placehold.co/32x32",
                        "https://placehold.co/32x32"
                      ],
                      additionalItemsCount: 3,
                      totalAmount: '345.000đ',
                      buttonLabel: l10n.ordersAcceptButton,
                      onButtonPressed: () {},
                      statusLabel: l10n.ordersNewOrderLabel,
                      labelBgColor: AppColors.colorFDAF0A,
                      labelTextColor: AppColors.color694600,
                    ),
                    const SizedBox(height: 16),
                    OrderItemCard(
                      orderCode: '#GF-88288',
                      timeAgo: l10n.ordersMinutesAgo(8),
                      items: '1x Bún Chả Hà Nội, 2x Nước Sâm',
                      avatars: const ["https://placehold.co/32x32"],
                      totalAmount: '185.000đ',
                      note: 'Ít bún nhiều rau',
                      buttonLabel: l10n.ordersAcceptButton,
                      isSecondaryButton: true,
                      onButtonPressed: () {},
                      statusLabel: l10n.ordersNewOrderLabel,
                      labelBgColor: AppColors.colorEEEEF0,
                      labelTextColor: AppColors.color434653,
                    ),
                    const SizedBox(height: 16),
                    OrderItemCard(
                      orderCode: '#GF-88285',
                      timeAgo: l10n.ordersMinutesAgo(15),
                      items: '5x Cơm Tấm Sườn Bì Chả',
                      avatars: const ["https://placehold.co/32x32"],
                      totalAmount: '425.000đ',
                      note: l10n.ordersLargeOrder,
                      buttonLabel: l10n.ordersAcceptButton,
                      isSecondaryButton: true,
                      onButtonPressed: () {},
                      statusLabel: l10n.ordersNewOrderLabel,
                      labelBgColor: AppColors.colorEEEEF0,
                      labelTextColor: AppColors.color434653,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class OrdersBody1 extends StatelessWidget {
  const OrdersBody1({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            // Phần Stats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: OrderStatCard(
                            title: l10n.ordersTotalOrders,
                            value: state.totalOrders.toString(),
                            bgColor: AppColors.colorF3F3F6,
                            textColor: AppColors.color1A1C1E,
                            labelColor: AppColors.color737784,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OrderStatCard(
                            title: l10n.ordersRevenue,
                            value: state.revenue,
                            bgColor: AppColors.colorFDAF0A,
                            textColor: AppColors.color694600,
                            labelColor: AppColors.color694600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    OrderStatCard(
                      title: l10n.ordersPerformance,
                      value:
                          '${l10n.ordersPerformanceGood} (${(state.performance * 100).toInt()}%)',
                      bgColor: AppColors.color004AAD,
                      textColor: Colors.white,
                      labelColor: AppColors.colorA9C1FF,
                      trailing: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child:
                            const Icon(Icons.trending_up, color: Colors.white),
                      ),
                    ), // performance card
                  ],
                ),
              ),
            ),

            // Phần Tabs
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      OrderTabItem(
                        label: l10n.ordersTabNew,
                        count: '4',
                        isActive: state.activeTab == OrderTab.newOrder,
                        onTap: () => context
                            .read<OrdersBloc>()
                            .add(const TabChangedEvent(OrderTab.newOrder)),
                      ),
                      const SizedBox(width: 8),
                      OrderTabItem(
                        label: l10n.ordersTabPreparing,
                        isActive: state.activeTab == OrderTab.preparing,
                        onTap: () => context
                            .read<OrdersBloc>()
                            .add(const TabChangedEvent(OrderTab.preparing)),
                      ),
                      const SizedBox(width: 8),
                      OrderTabItem(
                        label: l10n.ordersTabDone,
                        isActive: state.activeTab == OrderTab.done,
                        onTap: () => context
                            .read<OrdersBloc>()
                            .add(const TabChangedEvent(OrderTab.done)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          body: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            itemCount: 10, // hoặc state.orders.length
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: OrderItemCard(
                  orderCode: '#GF-88291',
                  timeAgo: l10n.ordersMinutesAgo(2),
                  items:
                      '2x Phở Bò Tái Lăn, 1x Trà Đào Cam Sả, 1x Gỏi Cuốn Tôm Thịt',
                  avatars: const [
                    "https://placehold.co/32x32",
                    "https://placehold.co/32x32"
                  ],
                  additionalItemsCount: 3,
                  totalAmount: '345.000đ',
                  buttonLabel: l10n.ordersAcceptButton,
                  onButtonPressed: () {},
                  statusLabel: l10n.ordersNewOrderLabel,
                  labelBgColor: AppColors.colorFDAF0A,
                  labelTextColor: AppColors.color694600,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
