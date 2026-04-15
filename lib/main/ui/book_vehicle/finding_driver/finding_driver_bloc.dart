import 'package:bloc/bloc.dart';
import 'package:demo_app/main/data/model/ride/ride.dart';
import 'package:demo_app/main/utils/service/local_notification_service.dart';
import 'package:equatable/equatable.dart';

part 'finding_driver_event.dart';
part 'finding_driver_state.dart';

class FindingDriverBloc extends Bloc<FindingDriverEvent, FindingDriverState> {
  final Ride? ride;
  FindingDriverBloc({this.ride})
      : super(FindingDriverState(
          pickupAddress: ride?.pickupAddress ?? '',
          destinationAddress: ride?.destinationAddress ?? '',
          estimatedPrice:
              double.tryParse(ride?.totalPrice ?? '0')?.toInt() ?? 0,
          distance: (ride?.distance?.toDouble() ?? 0.0) / 1000,
        )) {
    on<FindingDriverStartSearch>(_onStartSearch);
    on<FindingDriverCancelSearch>(_onCancelSearch);
    on<FindingDriverFound>(_onDriverFound);
    on<FindingDriverTimeout>(_onTimeout);
  }

  Future<void> _onStartSearch(
    FindingDriverStartSearch event,
    Emitter<FindingDriverState> emit,
  ) async {
    emit(state.copyWith(status: FindingDriverStatus.searching));

    // Simulate searching for a driver
    await Future.delayed(const Duration(seconds: 8));

    // Only emit if still searching (not cancelled)
    if (state.status == FindingDriverStatus.searching) {
      add(const FindingDriverFound());
    }
  }

  void _onCancelSearch(
    FindingDriverCancelSearch event,
    Emitter<FindingDriverState> emit,
  ) {
    emit(state.copyWith(status: FindingDriverStatus.cancelled));
  }

  void _onDriverFound(
    FindingDriverFound event,
    Emitter<FindingDriverState> emit,
  ) async {
    await LocalNotificationService.instance.showNotification(
      title: "Đặt xe thành công",
      body: "Chuyến đi của bạn đã được xác nhận",
    );
    emit(state.copyWith(status: FindingDriverStatus.found));
  }

  void _onTimeout(
    FindingDriverTimeout event,
    Emitter<FindingDriverState> emit,
  ) {
    emit(state.copyWith(status: FindingDriverStatus.timeout));
  }
}
