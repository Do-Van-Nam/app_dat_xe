import 'package:equatable/equatable.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final bool isRestaurantOpen;
  final bool isAutoAcceptOrders;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.isRestaurantOpen = true,
    this.isAutoAcceptOrders = true,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    bool? isRestaurantOpen,
    bool? isAutoAcceptOrders,
  }) {
    return DashboardState(
      status: status ?? this.status,
      isRestaurantOpen: isRestaurantOpen ?? this.isRestaurantOpen,
      isAutoAcceptOrders: isAutoAcceptOrders ?? this.isAutoAcceptOrders,
    );
  }

  @override
  List<Object?> get props => [status, isRestaurantOpen, isAutoAcceptOrders];
}
