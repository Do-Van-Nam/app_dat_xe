import 'package:flutter_bloc/flutter_bloc.dart';

import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardState()) {
    on<ToggleRestaurantStatusEvent>((event, emit) {
      emit(state.copyWith(isRestaurantOpen: !state.isRestaurantOpen));
    });

    on<ToggleAutoAcceptEvent>((event, emit) {
      emit(state.copyWith(isAutoAcceptOrders: !state.isAutoAcceptOrders));
    });
  }
}
