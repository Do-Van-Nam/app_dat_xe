import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  ActivityBloc() : super(ActivityInitial()) {
    on<LoadActivityEvent>(_onLoadActivity);
    on<TabChangedEvent>(_onTabChanged);
  }

  Future<void> _onLoadActivity(
      LoadActivityEvent event, Emitter<ActivityState> emit) async {
    emit(ActivityLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final List<ActivityItem> mockData = [
        ActivityItem(
          type: "Bike",
          date: "12 TH05, 2024",
          time: "14:30",
          pickup: "210 Võ Văn Kiệt, Quận 1",
          destination: "Landmark 81, Bình Thạnh",
          amount: "45.000đ",
          status: "HOÀN THÀNH",
          isSuccess: true,
          icon: Icons.pedal_bike,
        ),
        ActivityItem(
          type: "Car 4 Chỗ",
          date: "11 TH05, 2024",
          time: "08:15",
          pickup: "Sân bay Tân Sơn Nhất",
          destination: "",
          amount: "0đ",
          status: "ĐÃ HỦY",
          isSuccess: false,
          icon: Icons.directions_car,
        ),
        ActivityItem(
          type: "Giao hàng nhanh",
          date: "10 TH05, 2024",
          time: "19:45",
          pickup: "GX: Shop Quần Áo XYZ",
          destination: "Nhận: Nhà riêng - Quận...",
          amount: "32.000đ",
          status: "HOÀN THÀNH",
          isSuccess: true,
          icon: Icons.local_shipping,
        ),
        ActivityItem(
          type: "Giao hàng nhanh",
          date: "10 TH05, 2024",
          time: "19:45",
          pickup: "GX: Shop Quần Áo XYZ",
          destination: "Nhận: Nhà riêng - Quận...",
          amount: "32.000đ",
          status: "HOÀN THÀNH",
          isSuccess: true,
          icon: Icons.local_shipping,
        ),
      ];

      emit(ActivityLoaded(activities: mockData));
    } catch (e) {
      emit(ActivityError("Không thể tải hoạt động"));
    }
  }

  void _onTabChanged(TabChangedEvent event, Emitter<ActivityState> emit) {
    if (state is ActivityLoaded) {
      final current = state as ActivityLoaded;
      emit(ActivityLoaded(
        activities: current.activities,
        selectedTabIndex: event.tabIndex,
      ));
    }
  }
}
