part of 'activity_bloc.dart';

abstract class ActivityState {}

final class ActivityInitial extends ActivityState {}

final class ActivityLoading extends ActivityState {}

final class ActivityLoaded extends ActivityState {
  final List<ActivityItem> activities;
  final int selectedTabIndex; // 0: Chuyến xe, 1: Đơn hàng

  ActivityLoaded({
    required this.activities,
    this.selectedTabIndex = 0,
  });
}

final class ActivityError extends ActivityState {
  final String message;
  ActivityError(this.message);
}

// Model cho một hoạt động
class ActivityItem {
  final String type; // "Bike", "Car 4 Chỗ", "Giao hàng nhanh"
  final String date;
  final String time;
  final String pickup;
  final String destination;
  final String amount;
  final String status; // "HOÀN THÀNH", "ĐÃ HỦY"
  final bool isSuccess;
  final IconData icon;

  ActivityItem({
    required this.type,
    required this.date,
    required this.time,
    required this.pickup,
    required this.destination,
    required this.amount,
    required this.status,
    required this.isSuccess,
    required this.icon,
  });
}
