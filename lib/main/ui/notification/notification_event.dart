part of 'notification_bloc.dart';

abstract class NotificationEvent {}

class LoadNotificationsEvent extends NotificationEvent {}

class TabChangedEvent extends NotificationEvent {
  final int tabIndex; // 0: Tất cả, 1: Khuyến mãi, 2: Đơn hàng
  TabChangedEvent(this.tabIndex);
}

class MarkAsReadEvent extends NotificationEvent {
  final String notificationId;
  MarkAsReadEvent(this.notificationId);
}
