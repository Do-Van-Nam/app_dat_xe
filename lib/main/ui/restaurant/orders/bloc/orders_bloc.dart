import 'package:flutter_bloc/flutter_bloc.dart';
import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(const OrdersState()) {
    on<TabChangedEvent>((event, emit) {
      emit(state.copyWith(activeTab: event.tab));
    });

    on<AcceptOrderEvent>((event, emit) {
      // Handle accept order logic
    });
  }
}
