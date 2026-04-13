import 'dart:ffi';

import 'package:demo_app/main/data/model/ride/price.dart';
import 'package:demo_app/main/data/model/ride/vehicle.dart';
import 'package:demo_app/main/data/repository/ride_repository.dart';
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

    // Các event được thêm mới gọi API
    on<CreateRideEvent>(_onCreateRide);
    on<GetVehiclesEvent>(_onGetVehicles);
    on<GetPriceEvent>(_onGetPrice);
    on<ApplyPromoCodeEvent>(_onApplyPromoCode);
    on<UnApplyPromoCodeEvent>(_onUnApplyPromoCode);
    on<LoadInitialBookingData>(_onLoadInitialBookingData);
  }

  Future<void> _onLoadInitialBookingData(
      LoadInitialBookingData event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    await _onLoadOptions(LoadBookingOptionsEvent(), emit);
    try {
      print("bat dau load");
      await Future.wait([
        _onCreateRide(CreateRideEvent(event.request), emit),
        _onGetVehicles(GetVehiclesEvent(event.request), emit),
        _onGetPrice(GetPriceEvent(event.request), emit),
      ]);
      print("ket thuc load");
    } catch (e) {
      print("loi load: $e");
    }
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

  Future<void> _onSelectVehicle(
      SelectVehicleEvent event, Emitter<BookingState> emit) async {
    if (state is BookingLoaded) {
      final current = state as BookingLoaded;
      final selectedVehicle =
          current.vehicles.firstWhere((v) => v.id == event.vehicleId);
      await _onGetPrice(
          GetPriceEvent(event.request
              .copyWith(vehicleType: int.parse(selectedVehicle.id))),
          emit);

      emit(current.copyWith(
        selectedVehicleId: event.vehicleId,
        totalAmount: selectedVehicle.price,
      ));
    }
  }

  Future<void> _onCreateRide(
      CreateRideEvent event, Emitter<BookingState> emit) async {
    if (state is! BookingLoaded) {
      print("state khong phai BookingLoaded");
      return;
    }
    final current = state as BookingLoaded;

    final (success, ride) =
        await RideRepository().createDraftRide(event.request.toJson());

    if (success && ride != null) {
      print("Ride created: ${ride.id}");
      emit(current.copyWith(rideId: ride.id?.toString()));
    }
  }

  Future<void> _onGetVehicles(
      GetVehiclesEvent event, Emitter<BookingState> emit) async {
    if (state is! BookingLoaded) return;
    BookingLoaded current = state as BookingLoaded;

    String? rId = current.rideId;
    if (rId == null) {
      final (success, ride) =
          await RideRepository().createDraftRide(event.request.toJson());
      if (success && ride != null) {
        rId = ride.id?.toString();
        current = current.copyWith(rideId: rId);
        emit(current);
      } else {
        return;
      }
    }

    final (successVehicles, list) = await RideRepository().getVehicles(rId);

    if (successVehicles && list.isNotEmpty) {
      final options = list.map((v) {
        String iconAsset = AppImages.icCar;
        if (v.vehicleType == 1) iconAsset = AppImages.icBike2;
        if (v.vehicleType == 7) iconAsset = AppImages.icBus;

        return VehicleOption(
          id: v.vehicleType?.toString() ?? "1",
          name: v.name ?? "",
          price: v.estimatedFare?.toInt() ?? 0,
          time: v.estimatedWaitTime ?? "",
          tag: v.description ?? "",
          icon: iconAsset,
          tagColor: Colors.blue,
        );
      }).toList();

      emit(current.copyWith(vehicles: options));
    }
  }

  Future<void> _onGetPrice(
      GetPriceEvent event, Emitter<BookingState> emit) async {
    if (state is! BookingLoaded) return;
    BookingLoaded current = state as BookingLoaded;

    String? rId = current.rideId;
    if (rId == null) {
      final (success, ride) =
          await RideRepository().createDraftRide(event.request.toJson());
      if (success && ride != null) {
        rId = ride.id?.toString();
        current = current.copyWith(rideId: rId);
        emit(current);
      } else {
        return;
      }
    }

    final (success, price) = await RideRepository().getPrice(rId);
    if (success && price != null) {
      print("gia chuyen ${price.finalFare}");
      emit(current.copyWith(
        price: price,
        totalAmount: price.finalFare?.toInt() ?? 0,
      ));
    }
  }

  Future<void> _onApplyPromoCode(
      ApplyPromoCodeEvent event, Emitter<BookingState> emit) async {
    if (state is BookingLoaded) {
      final current = state as BookingLoaded;
      if (current.rideId == null) return;

      final (success, price) =
          await RideRepository().applyVoucher(current.rideId, event.code);

      if (success && price != null) {
        emit(current.copyWith(
          promoCode: event.code,
          price: price,
          totalAmount: price.finalFare?.toInt() ?? 0,
        ));
      }
    }
  }

  Future<void> _onUnApplyPromoCode(
      UnApplyPromoCodeEvent event, Emitter<BookingState> emit) async {
    if (state is BookingLoaded) {
      final current = state as BookingLoaded;
      if (current.rideId == null) return;

      final (success, price) =
          await RideRepository().removeVoucher(current.rideId);

      if (success && price != null) {
        // Sử dụng chuỗi rỗng để xóa khỏi copyWith vì null bị bỏ qua
        emit(current.copyWith(
          price: price,
          totalAmount: price.finalFare?.toInt() ?? 0,
          promoCode: "",
        ));
      }
    }
  }
}
