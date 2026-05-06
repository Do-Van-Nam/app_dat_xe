import 'package:equatable/equatable.dart';
import 'orders_state.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class TabChangedEvent extends OrdersEvent {
  final OrderTab tab;
  const TabChangedEvent(this.tab);

  @override
  List<Object?> get props => [tab];
}

class AcceptOrderEvent extends OrdersEvent {
  final String orderId;
  const AcceptOrderEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}
