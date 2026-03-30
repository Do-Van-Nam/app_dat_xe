import 'package:demo_app/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notification_bloc.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => NotificationBloc()..add(LoadNotificationsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.notifications),
          leading: const BackButton(),
        ),
        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is NotificationError) {
              return Center(child: Text(state.message));
            }

            if (state is NotificationLoaded) {
              final filteredNotifications = state.selectedTabIndex == 0
                  ? state.notifications
                  : state.notifications.where((n) {
                      if (state.selectedTabIndex == 1)
                        return n.category == "KHUYẾN MÃI";
                      if (state.selectedTabIndex == 2)
                        return n.category == "ĐƠN HÀNG";
                      return true;
                    }).toList();

              return RefreshIndicator(
                onRefresh: () async => context
                    .read<NotificationBloc>()
                    .add(LoadNotificationsEvent()),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Tabs
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          _buildTab(
                              context, l10n.all, 0, state.selectedTabIndex),
                          _buildTab(context, l10n.promotions, 1,
                              state.selectedTabIndex),
                          _buildTab(
                              context, l10n.orders, 2, state.selectedTabIndex),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Danh sách thông báo
                    ...filteredNotifications
                        .map((noti) =>
                            _buildNotificationItem(context, noti, l10n))
                        .toList(),

                    if (filteredNotifications.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: Text("Không có thông báo nào"),
                        ),
                      ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.home), label: l10n.home),
            BottomNavigationBarItem(
                icon: const Icon(Icons.article), label: l10n.activity),
            BottomNavigationBarItem(
                icon: const Icon(Icons.person), label: l10n.profile),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(
      BuildContext context, String title, int index, int selectedIndex) {
    final isSelected = index == selectedIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () =>
            context.read<NotificationBloc>().add(TabChangedEvent(index)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.blue : Colors.grey[700],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
      BuildContext context, NotificationItem item, AppLocalizations l10n) {
    if (item.imageUrl != null) {
      // Banner lớn
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Image.network(
                item.imageUrl!,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black54],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.message,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Thông báo thông thường
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: item.iconBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(item.icon,
              color: item.iconBackgroundColor == Colors.transparent
                  ? null
                  : Colors.white),
        ),
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(item.message, style: const TextStyle(height: 1.4)),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  item.timeAgo,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                const SizedBox(width: 8),
                Text(
                  "•",
                  style: TextStyle(color: Colors.grey[400]),
                ),
                const SizedBox(width: 8),
                Text(
                  item.category,
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: item.isUnread
            ? const Icon(Icons.circle, size: 10, color: Colors.blue)
            : null,
        onTap: () {
          context.read<NotificationBloc>().add(MarkAsReadEvent(item.id));
          // TODO: Navigate to detail if needed
        },
      ),
    );
  }
}
