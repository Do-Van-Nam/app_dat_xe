import 'package:equatable/equatable.dart';

enum OrdersStatus { initial, loading, success, failure }
enum OrderTab { newOrder, preparing, done }

class OrdersState extends Equatable {
  final OrdersStatus status;
  final OrderTab activeTab;
  final int totalOrders;
  final String revenue;
  final double performance;

  const OrdersState({
    this.status = OrdersStatus.initial,
    this.activeTab = OrderTab.newOrder,
    this.totalOrders = 128,
    this.revenue = '12.4M',
    this.performance = 0.98,
  });

  OrdersState copyWith({
    OrdersStatus? status,
    OrderTab? activeTab,
    int? totalOrders,
    String? revenue,
    double? performance,
  }) {
    return OrdersState(
      status: status ?? this.status,
      activeTab: activeTab ?? this.activeTab,
      totalOrders: totalOrders ?? this.totalOrders,
      revenue: revenue ?? this.revenue,
      performance: performance ?? this.performance,
    );
  }

  @override
  List<Object?> get props => [status, activeTab, totalOrders, revenue, performance];
}
