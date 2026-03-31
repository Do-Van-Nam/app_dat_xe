import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'tracking_event.dart';
part 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  TrackingBloc() : super(TrackingInitial()) {
    on<LoadTrackingDataEvent>(_onLoadData);
    on<CancelRideEvent>(_onCancelRide);
  }

  Future<void> _onLoadData(
      LoadTrackingDataEvent event, Emitter<TrackingState> emit) async {
    emit(TrackingLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      emit(TrackingLoaded(
        driverName: "Nguyễn Văn A",
        vehiclePlate: "59-A1123.45",
        vehicleName: "Yamaha Exciter",
        rating: 4.9,
        arrivalTime: "KHOẢNG 2 PHÚT",
        distance: 0.8,
        discountedPrice: 32000,
        originalPrice: 45000,
        pickupAddress: "123 Lê Lợi, Quận 1",
        destinationAddress: "Landmark 81, Bình Thạnh",
      ));
    } catch (e) {
      emit(TrackingError("Không thể tải thông tin theo dõi"));
    }
  }

  void _onCancelRide(CancelRideEvent event, Emitter<TrackingState> emit) {
    // Thực tế sẽ gọi API hủy chuyến
    emit(TrackingError("Chuyến đã được hủy"));
  }
}
