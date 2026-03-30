part of 'notification_bloc.dart';

abstract class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class NotificationLoading extends NotificationState {}

final class NotificationLoaded extends NotificationState {
  final List<NotificationItem> notifications;
  final int selectedTabIndex;

  NotificationLoaded({
    required this.notifications,
    this.selectedTabIndex = 0,
  });
}

final class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}

// Model cho một thông báo
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String timeAgo;
  final String category; // "KHUYẾN MÃI", "ĐƠN HÀNG", "HỆ THỐNG"
  final IconData icon;
  final Color iconBackgroundColor;
  final bool isUnread;
  final String? imageUrl; // cho banner lớn

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.category,
    required this.icon,
    required this.iconBackgroundColor,
    this.isUnread = true,
    this.imageUrl,
  });
}
