import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<LoadNotificationsEvent>(_onLoadNotifications);
    on<TabChangedEvent>(_onTabChanged);
    on<MarkAsReadEvent>(_onMarkAsRead);
  }

  Future<void> _onLoadNotifications(
      LoadNotificationsEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 700));

      final List<NotificationItem> mockNotifications = [
        NotificationItem(
          id: "1",
          title: "Mã giảm 50% sắp hết hạn!",
          message:
              'Nhanh tay sử dụng mã "FOODIES50" để được giảm trực tiếp 50k cho đơn...',
          timeAgo: "5 PHÚT TRƯỚC",
          category: "KHUYẾN MÃI",
          icon: Icons.card_giftcard,
          iconBackgroundColor: Colors.orange,
          isUnread: true,
        ),
        NotificationItem(
          id: "2",
          title: "Giao hàng thành công",
          message:
              "Đơn hàng #SHP9921 đã được giao thành công bởi tài xế Nguyễn Văn A....",
          timeAgo: "2 GIỜ TRƯỚC",
          category: "ĐƠN HÀNG",
          icon: Icons.receipt_long,
          iconBackgroundColor: Colors.blue[100]!,
          isUnread: true,
        ),
        NotificationItem(
          id: "3",
          title: "Đại tiệc sinh nhật 5 tuổi",
          message: "Săn ngay deal 0đ và hàng ngàn voucher cực phẩm",
          timeAgo: "",
          category: "",
          icon: Icons.celebration,
          iconBackgroundColor: Colors.transparent,
          isUnread: false,
          imageUrl: "https://picsum.photos/id/1015/600/200",
        ),
        NotificationItem(
          id: "4",
          title: "Bảo trì hệ thống định kỳ",
          message:
              "Hệ thống sẽ tạm ngưng hoạt động từ 01:00 đến 03:00 sáng mai để nâng cấp...",
          timeAgo: "1 NGÀY TRƯỚC",
          category: "HỆ THỐNG",
          icon: Icons.info_outline,
          iconBackgroundColor: Colors.grey[200]!,
          isUnread: false,
        ),
        NotificationItem(
          id: "5",
          title: "Đơn hàng đang đến",
          message: "Tài xế đang cách bạn 2km. Hãy sẵn sàng nhận hàng nhé!",
          timeAgo: "HÔM QUA",
          category: "ĐƠN HÀNG",
          icon: Icons.local_shipping,
          iconBackgroundColor: Colors.green,
          isUnread: true,
        ),
        NotificationItem(
          id: "6",
          title: "Quà tặng tri ân thành viên",
          message:
              "Chúc mừng bạn đã thăng hạng Gold! Nhận ngay ưu tiên đặt xe và giảm phí...",
          timeAgo: "2 NGÀY TRƯỚC",
          category: "KHUYẾN MÃI",
          icon: Icons.workspace_premium,
          iconBackgroundColor: Colors.amber,
          isUnread: false,
        ),
      ];

      emit(NotificationLoaded(notifications: mockNotifications));
    } catch (e) {
      emit(NotificationError("Không thể tải thông báo"));
    }
  }

  void _onTabChanged(TabChangedEvent event, Emitter<NotificationState> emit) {
    if (state is NotificationLoaded) {
      final current = state as NotificationLoaded;
      emit(NotificationLoaded(
        notifications: current.notifications,
        selectedTabIndex: event.tabIndex,
      ));
    }
  }

  void _onMarkAsRead(MarkAsReadEvent event, Emitter<NotificationState> emit) {
    // TODO: Thực tế sẽ gọi API đánh dấu đã đọc
    if (state is NotificationLoaded) {
      final current = state as NotificationLoaded;
      final updatedList = current.notifications.map((noti) {
        if (noti.id == event.notificationId) {
          return NotificationItem(
            id: noti.id,
            title: noti.title,
            message: noti.message,
            timeAgo: noti.timeAgo,
            category: noti.category,
            icon: noti.icon,
            iconBackgroundColor: noti.iconBackgroundColor,
            isUnread: false,
            imageUrl: noti.imageUrl,
          );
        }
        return noti;
      }).toList();

      emit(NotificationLoaded(
        notifications: updatedList,
        selectedTabIndex: current.selectedTabIndex,
      ));
    }
  }
}
