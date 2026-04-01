import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

part 'airport_booking_event.dart';
part 'airport_booking_state.dart';

class AirportBookingBloc
    extends Bloc<AirportBookingEvent, AirportBookingState> {
  AirportBookingBloc() : super(AirportBookingInitial()) {
    on<LoadAirportBookingEvent>(_onLoad);
    on<SelectTripTypeEvent>(_onSelectTripType);
    on<SelectVehicleEvent>(_onSelectVehicle);
  }

  Future<void> _onLoad(
      LoadAirportBookingEvent event, Emitter<AirportBookingState> emit) async {
    emit(AirportBookingLoading());
    await Future.delayed(const Duration(milliseconds: 700));

    final airports = [
      Airport(
          name: "Sân bay Tân Sơn Nhất",
          subtitle: "TP. Hồ Chí Minh",
          distance: "8.2 km"),
      Airport(
          name: "Sân bay Long Thành",
          subtitle: "Sắp ra mắt • Đồng Nai",
          distance: ""),
    ];

    final vehicles = [
      VehicleOption(
        id: "taxi",
        name: "Taxi sân bay",
        price: 245000,
        passengers: "4",
        luggage: "2",
        tag: "GIÁ CỐ ĐỊNH",
        tagColor: Colors.green,
        imageUrl: "https://picsum.photos/id/1074/200/120",
      ),
      VehicleOption(
        id: "car4",
        name: "Xe 4 chỗ Riêng",
        price: 280000,
        passengers: "4",
        luggage: "3",
        tag: "PHỔ BIẾN",
        tagColor: Colors.blue,
        imageUrl: "https://picsum.photos/id/1071/200/120",
      ),
      VehicleOption(
        id: "suv7",
        name: "Xe 7 chỗ SUV",
        price: 350000,
        passengers: "7",
        luggage: "5",
        tag: "XE RỘNG",
        tagColor: Colors.orange,
        imageUrl: "https://picsum.photos/id/1072/200/120",
      ),
    ];

    emit(AirportBookingLoaded(
      nearbyAirports: airports,
      vehicles: vehicles,
    ));
  }

  void _onSelectTripType(
      SelectTripTypeEvent event, Emitter<AirportBookingState> emit) {
    if (state is AirportBookingLoaded) {
      final current = state as AirportBookingLoaded;
      emit(AirportBookingLoaded(
        selectedTripType: event.index,
        nearbyAirports: current.nearbyAirports,
        vehicles: current.vehicles,
        selectedVehicleId: current.selectedVehicleId,
      ));
    }
  }

  void _onSelectVehicle(
      SelectVehicleEvent event, Emitter<AirportBookingState> emit) {
    if (state is AirportBookingLoaded) {
      final current = state as AirportBookingLoaded;
      emit(AirportBookingLoaded(
        selectedTripType: current.selectedTripType,
        nearbyAirports: current.nearbyAirports,
        vehicles: current.vehicles,
        selectedVehicleId: event.vehicleId,
      ));
    }
  }
}
