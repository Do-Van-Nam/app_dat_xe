import 'package:demo_app/main/data/model/goong/place_detail.dart';
import 'package:demo_app/main/data/model/unique_error.dart';
import 'package:demo_app/main/data/repository/goong_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:demo_app/main/data/repository/ride_repository.dart';
import 'package:demo_app/main/data/model/ride/vehicle.dart';
import 'package:demo_app/main/data/model/goong/location.dart';

part 'interprovince_ride_event.dart';
part 'interprovince_ride_state.dart';

class InterprovinceRideBloc
    extends Bloc<InterprovinceRideEvent, InterprovinceRideState> {
  InterprovinceRideBloc() : super(InterprovinceRideInitial()) {
    on<LoadInitialData>(_onLoadInitialData);
    on<SelectVehicleType>(_onSelectVehicleType);
    on<ChangeDate>(_onChangeDate);
    on<ChangePickupTime>(_onChangePickupTime);
    on<SavePickupPlaceIdEvent>(_onSavePickupPlaceId);
    on<SaveDestinationPlaceIdEvent>(_onSaveDestinationPlaceId);
    on<FetchCurrentLocationEvent>(_onFetchCurrentLocation);
    on<FetchVehiclesEvent>(_onFetchVehicles);
    on<BookInterprovinceRideEvent>(_onBookInterprovinceRide);
  }

  void _checkAndFetchVehicles(InterprovinceRideLoaded state) {
    if (state.pickupPlaceId.isNotEmpty && state.destinationPlaceId.isNotEmpty) {
      add(FetchVehiclesEvent());
    }
  }

  void _onLoadInitialData(
      LoadInitialData event, Emitter<InterprovinceRideState> emit) {
    emit(InterprovinceRideLoaded(
      selectedDate: DateTime.now(),
      pickupTime: TimeOfDay.now(),
      vehicles: const [],
    ));
  }

  void _onSelectVehicleType(
      SelectVehicleType event, Emitter<InterprovinceRideState> emit) {
    if (state is InterprovinceRideLoaded) {
      final current = state as InterprovinceRideLoaded;
      emit(current.copyWith(selectedVehicleType: event.vehicleType));
    }
  }

  void _onChangeDate(ChangeDate event, Emitter<InterprovinceRideState> emit) {
    if (state is InterprovinceRideLoaded) {
      emit((state as InterprovinceRideLoaded)
          .copyWith(selectedDate: event.newDate));
    }
  }

  void _onChangePickupTime(
      ChangePickupTime event, Emitter<InterprovinceRideState> emit) {
    if (state is InterprovinceRideLoaded) {
      emit((state as InterprovinceRideLoaded)
          .copyWith(pickupTime: event.newTime));
    }
  }

  Future<void> _onSavePickupPlaceId(SavePickupPlaceIdEvent event,
      Emitter<InterprovinceRideState> emit) async {
    if (state is InterprovinceRideLoaded) {
      final current = state as InterprovinceRideLoaded;
      try {
        final (success, locations) = await GoongRepository().getPlaceDetail(
          placeId: event.placeId,
        );
        if (success && locations?.geometry != null) {
          final newState = current.copyWith(
            pickupPlaceId: event.placeId,
            pickupPoint: event.address,
            pickupCoords: locations?.geometry?.location,
          );
          emit(newState);
          _checkAndFetchVehicles(newState);
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> _onSaveDestinationPlaceId(SaveDestinationPlaceIdEvent event,
      Emitter<InterprovinceRideState> emit) async {
    if (state is InterprovinceRideLoaded) {
      final current = state as InterprovinceRideLoaded;
      try {
        final (success, locations) = await GoongRepository().getPlaceDetail(
          placeId: event.placeId,
        );
        if (success && locations?.geometry != null) {
          final newState = current.copyWith(
              destinationPlaceId: event.placeId,
              destination: event.address,
              destinationCoords: locations?.geometry?.location);
          emit(newState);
          _checkAndFetchVehicles(newState);
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> _onFetchVehicles(
      FetchVehiclesEvent event, Emitter<InterprovinceRideState> emit) async {
    if (state is! InterprovinceRideLoaded) return;
    final current = state as InterprovinceRideLoaded;

    if (current.pickupPlaceId.isEmpty || current.destinationPlaceId.isEmpty) {
      return;
    }

    emit(current.copyWith(vehicles: [])); // clear existing

    // 1. Create draft ride (service_type = 3 for interprovince, assuming)
    final (okDraft, draftRide) = await RideRepository().createDraftRide({
      "pickup_address": current.currentLocation,
      "pickup_lat": current.pickupCoords?.lat,
      "pickup_lng": current.pickupCoords?.lng,
      "destination_address": current.destination,
      "destination_lat": current.destinationCoords?.lat,
      "destination_lng": current.destinationCoords?.lng,
      "vehicle_type": "2",
    });

    if (okDraft && draftRide != null) {
      // 2. Fetch vehicles
      final (okVehicles, vehicleList) =
          await RideRepository().getVehicles(draftRide.id);

      if (okVehicles) {
        emit(
            (state as InterprovinceRideLoaded).copyWith(vehicles: vehicleList));
      }
    }
  }

  Future<void> _onFetchCurrentLocation(FetchCurrentLocationEvent event,
      Emitter<InterprovinceRideState> emit) async {
    if (state is! InterprovinceRideLoaded) return;
    final current = state as InterprovinceRideLoaded;

    emit(current.copyWith(isLoadingLocation: true));

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(current.copyWith(
          isLoadingLocation: false,
          currentLocation: "Vui lòng bật GPS",
        ));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        emit(current.copyWith(
          isLoadingLocation: false,
          currentLocation: "Không có quyền truy cập vị trí",
        ));
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      String addressText = "${position.latitude.toStringAsFixed(5)}, "
          "${position.longitude.toStringAsFixed(5)}";

      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final parts = <String>[
            if (p.street?.isNotEmpty == true) p.street!,
            if (p.subAdministrativeArea?.isNotEmpty == true)
              p.subAdministrativeArea!,
            if (p.administrativeArea?.isNotEmpty == true) p.administrativeArea!,
          ];
          if (parts.isNotEmpty) {
            addressText = parts.join(", ");
          }
        }
      } catch (geoError) {
        print("⚠️ Geocoding error: $geoError");
      }

      final newState = current.copyWith(
        isLoadingLocation: false,
        currentLocation: addressText,
        pickupPoint: addressText,
        pickupPlaceId: "didGetFromGPS",
        pickupCoords: GoongLocationCoords(
          lat: position.latitude,
          lng: position.longitude,
        ),
      );
      emit(newState);
      _checkAndFetchVehicles(newState);
    } catch (e) {
      emit(current.copyWith(
        isLoadingLocation: false,
        currentLocation: "Không thể lấy vị trí",
      ));
    }
  }

  Future<void> _onBookInterprovinceRide(BookInterprovinceRideEvent event,
      Emitter<InterprovinceRideState> emit) async {
    if (state is! InterprovinceRideLoaded) return;
    final current = state as InterprovinceRideLoaded;

    if (current.pickupPlaceId.isEmpty ||
        current.destinationPlaceId.isEmpty ||
        current.selectedVehicleType == null) {
      return;
    }

    final String travelDate =
        "${current.selectedDate.year}-${current.selectedDate.month.toString().padLeft(2, '0')}-${current.selectedDate.day.toString().padLeft(2, '0')}";
    final String travelTime =
        "${current.pickupTime.hour.toString().padLeft(2, '0')}:${current.pickupTime.minute.toString().padLeft(2, '0')}";
    final body = {
      "pickup_address": current.pickupPoint,
      "pickup_lat": current.pickupCoords?.lat,
      "pickup_lng": current.pickupCoords?.lng,
      "destination_address": current.destination,
      "destination_lat": current.destinationCoords?.lat,
      "destination_lng": current.destinationCoords?.lng,
      "travel_date": travelDate,
      "travel_time": travelTime,
      "vehicle_type": current.selectedVehicleType,
    };
    final (
      ok,
      rideId,
    ) = await RideRepository().bookInterCityRide(body);
    if (ok && rideId != null) {
      emit(InterprovinceRideSuccess(rideId));
    } else {
      emit(current.copyWith(uniqueError: UniqueError("Đã có lỗi xảy ra.")));
    }
  }
}
