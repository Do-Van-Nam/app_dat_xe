import 'package:demo_app/res/app_images.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(BookingInitial()) {
    on<LoadBookingOptionsEvent>(_onLoadOptions);
    on<SelectVehicleEvent>(_onSelectVehicle);
    on<ApplyPromoCodeEvent>(_onApplyPromoCode);
  }

  Future<void> _onLoadOptions(
      LoadBookingOptionsEvent event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final vehicles = [
        VehicleOption(
          id: "bike",
          name: "Xe máy",
          price: 12000,
          time: "3p",
          tag: "TIẾT KIỆM",
          icon: AppImages.icBike2,
          tagColor: Colors.green,
        ),
        VehicleOption(
          id: "car4",
          name: "Ô tô 4 chỗ",
          price: 45000,
          time: "5p",
          tag: "PHỔ BIẾN",
          icon: AppImages.icCar,
          tagColor: Colors.blue,
        ),
        VehicleOption(
          id: "car7",
          name: "Ô tô 7 chỗ",
          price: 60000,
          time: "8p",
          tag: "GIA ĐÌNH",
          icon: AppImages.icBus,
          tagColor: Colors.grey,
        ),
      ];

      emit(BookingLoaded(
        pickupAddress: "123 Lê Lợi, Quận 1",
        destinationAddress: "Landmark 81, Bình Thạnh",
        vehicles: vehicles,
        selectedVehicleId: "car4",
        totalAmount: 45000,
      ));
    } catch (e) {
      emit(BookingError("Không thể tải thông tin đặt xe"));
    }
  }

  void _onSelectVehicle(SelectVehicleEvent event, Emitter<BookingState> emit) {
    if (state is BookingLoaded) {
      final current = state as BookingLoaded;
      final selectedVehicle =
          current.vehicles.firstWhere((v) => v.id == event.vehicleId);

      emit(BookingLoaded(
        pickupAddress: current.pickupAddress,
        destinationAddress: current.destinationAddress,
        vehicles: current.vehicles,
        selectedVehicleId: event.vehicleId,
        promoCode: current.promoCode,
        totalAmount: selectedVehicle.price,
      ));
    }
  }

  void _onApplyPromoCode(
      ApplyPromoCodeEvent event, Emitter<BookingState> emit) {
    // Giả lập áp dụng mã giảm giá
    if (state is BookingLoaded) {
      final current = state as BookingLoaded;
      emit(BookingLoaded(
        pickupAddress: current.pickupAddress,
        destinationAddress: current.destinationAddress,
        vehicles: current.vehicles,
        selectedVehicleId: current.selectedVehicleId,
        promoCode: event.code,
        totalAmount: (current.totalAmount * 0.9).toInt(), // giảm 10%
      ));
    }
  }
}
