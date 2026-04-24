import 'package:demo_app/main/data/model/goong/place_detail.dart';
import 'package:demo_app/main/data/repository/goong_repository.dart';
import 'package:demo_app/main/data/repository/ride_repository.dart';
import 'package:demo_app/main/data/model/ride/airport.dart';
import 'package:demo_app/main/data/model/ride/vehicle.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
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
    on<SelectAirportEvent>(_onSelectAirport);
    on<FetchCurrentLocationEvent>(_onFetchCurrentLocation);
    on<SavePickupPlaceIdEvent>(_onSavePickupPlaceId);
    on<ChangeDate>(_onChangeDate);
    on<ChangePickupTime>(_onChangePickupTime);
    on<FetchVehiclesEvent>(_onFetchVehicles);
    on<BookAirportRideEvent>(_onBookAirportRide);
  }

  void _checkAndFetchVehicles(AirportBookingLoaded state) {
    if (state.pickupPlaceId.isNotEmpty && state.selectedAirport != null) {
      add(FetchVehiclesEvent());
    }
  }

  Future<void> _onLoad(
      LoadAirportBookingEvent event, Emitter<AirportBookingState> emit) async {
    emit(AirportBookingLoading());
    await Future.delayed(const Duration(milliseconds: 700));

    final (ok, fetchedAirports) = await RideRepository().getAirports();
    final airports = ok ? fetchedAirports : <Airport>[];

    emit(AirportBookingLoaded(
      nearbyAirports: airports,
      selectedAirport: airports.isNotEmpty ? airports.first : null,
      vehicles: const [],
      pickupPlaceId: "",
      selectedDate: DateTime.now(),
      pickupTime: TimeOfDay.now(),
    ));
  }

  void _onSelectTripType(
      SelectTripTypeEvent event, Emitter<AirportBookingState> emit) {
    if (state is AirportBookingLoaded) {
      final current = state as AirportBookingLoaded;
      final newState = current.copyWith(selectedTripType: event.index);
      emit(newState);
      _checkAndFetchVehicles(newState);
    }
  }

  void _onSelectVehicle(
      SelectVehicleEvent event, Emitter<AirportBookingState> emit) {
    if (state is AirportBookingLoaded) {
      final current = state as AirportBookingLoaded;
      emit(current.copyWith(selectedVehicleType: event.vehicleType));
    }
  }

  void _onSelectAirport(
      SelectAirportEvent event, Emitter<AirportBookingState> emit) {
    if (state is AirportBookingLoaded) {
      final current = state as AirportBookingLoaded;
      final newState = current.copyWith(selectedAirport: event.airport);
      emit(newState);
      _checkAndFetchVehicles(newState);
    }
  }

  Future<void> _onSavePickupPlaceId(
      SavePickupPlaceIdEvent event, Emitter<AirportBookingState> emit) async {
    if (state is AirportBookingLoaded) {
      try {
        final (success, locations) = await GoongRepository().getPlaceDetail(
          placeId: event.pickupPlaceId,
        );
        if (success && locations?.geometry != null) {
          emit((state as AirportBookingLoaded).copyWith(
              pickupCoords: locations?.geometry?.location,
              pickupPlaceId: event.pickupPlaceId));
          _checkAndFetchVehicles(state as AirportBookingLoaded);
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  void _onChangeDate(ChangeDate event, Emitter<AirportBookingState> emit) {
    if (state is AirportBookingLoaded) {
      emit((state as AirportBookingLoaded).copyWith(selectedDate: event.date));
    }
  }

  void _onChangePickupTime(
      ChangePickupTime event, Emitter<AirportBookingState> emit) {
    if (state is AirportBookingLoaded) {
      emit((state as AirportBookingLoaded).copyWith(pickupTime: event.time));
    }
  }

  Future<void> _onFetchVehicles(
      FetchVehiclesEvent event, Emitter<AirportBookingState> emit) async {
    if (state is! AirportBookingLoaded) return;
    final current = state as AirportBookingLoaded;

    if (current.pickupPlaceId.isEmpty || current.selectedAirport == null) {
      return;
    }

    emit(current.copyWith(
        vehicles: [])); // clear existing, maybe show loading state later

    // 1. Create draft ride
    final pickup = current.selectedTripType == 0
        ? current.pickupPlaceId
        : current.selectedAirport!.id.toString();
    final destination = current.selectedTripType == 0
        ? current.selectedAirport!.id.toString()
        : current.pickupPlaceId;

    // Gọi API create draft ride (bạn cần truyền đúng param theo API của bạn)
    final (okDraft, draftRide) = await RideRepository().createDraftRide({
      "pickup_address": current.selectedTripType == 0
          ? current.selectedAirport!.name ?? ""
          : current.currentLocation,
      "pickup_lat": current.selectedTripType == 0
          ? current.selectedAirport!.lat
          : current.pickupCoords?.lat,
      "pickup_lng": current.selectedTripType == 0
          ? current.selectedAirport!.lng
          : current.pickupCoords?.lng,
      "destination_address": current.selectedTripType == 0
          ? current.currentLocation
          : current.selectedAirport!.name,
      "destination_lat": current.selectedTripType == 0
          ? current.pickupCoords?.lat
          : current.selectedAirport!.lat,
      "destination_lng": current.selectedTripType == 0
          ? current.pickupCoords?.lng
          : current.selectedAirport!.lng,
      "vehicle_type": "2",
    });

    if (okDraft && draftRide != null) {
      // 2. Fetch vehicles
      final (okVehicles, vehicleList) =
          await RideRepository().getVehicles(draftRide.id);

      if (okVehicles) {
        emit((state as AirportBookingLoaded).copyWith(vehicles: vehicleList));
      }
    }
  }

  Future<void> _onBookAirportRide(
      BookAirportRideEvent event, Emitter<AirportBookingState> emit) async {
    if (state is! AirportBookingLoaded) return;
    final current = state as AirportBookingLoaded;

    if (current.pickupCoords == null ||
        current.selectedAirport == null ||
        current.selectedVehicleType == null) {
      return;
    }

    final isToAirport = current.selectedTripType == 0;

    final pickupAddress =
        isToAirport ? current.currentLocation : current.selectedAirport!.name;
    final pickupLat =
        isToAirport ? current.pickupCoords!.lat : current.selectedAirport!.lat;
    final pickupLng =
        isToAirport ? current.pickupCoords!.lng : current.selectedAirport!.lng;

    final destAddress =
        isToAirport ? current.selectedAirport!.name : current.currentLocation;
    final destLat =
        isToAirport ? current.selectedAirport!.lat : current.pickupCoords!.lat;
    final destLng =
        isToAirport ? current.selectedAirport!.lng : current.pickupCoords!.lng;

    final String travelDate =
        "${current.selectedDate.year}-${current.selectedDate.month.toString().padLeft(2, '0')}-${current.selectedDate.day.toString().padLeft(2, '0')}";
    final String travelTime =
        "${current.pickupTime.hour.toString().padLeft(2, '0')}:${current.pickupTime.minute.toString().padLeft(2, '0')}";

    final body = {
      "pickup_address": pickupAddress,
      "pickup_lat": pickupLat,
      "pickup_lng": pickupLng,
      "destination_address": destAddress,
      "destination_lat": destLat,
      "destination_lng": destLng,
      "travel_date": travelDate,
      "travel_time": travelTime,
      "vehicle_type": current.selectedVehicleType,
      "airport_id": current.selectedAirport!.id,
      "airport_direction": isToAirport ? 1 : 2,
    };

    // emit(loading) if needed? The ui might just show a dialog.

    final (ok, rideId) = await RideRepository().bookAirportRide(body);
    if (ok && rideId != null) {
      print("✅ Đặt xe sân bay thành công: ${rideId}");
      // TODO: Navigate or emit success state
      emit(AirportBookingSuccess(rideId));
    } else {
      print("❌ Đặt xe sân bay thất bại");
      // TODO: Emit error state
      emit(AirportBookingError("Đặt xe sân bay thất bại"));
    }
  }

  Future<void> _onFetchCurrentLocation(FetchCurrentLocationEvent event,
      Emitter<AirportBookingState> emit) async {
    if (state is! AirportBookingLoaded) return;
    final current = state as AirportBookingLoaded;

    // Hiển thị loading spinner trên nút
    emit(current.copyWith(isLoadingLocation: true));

    try {
      // 1. Kiểm tra location service
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(current.copyWith(
          isLoadingLocation: false,
          currentLocation: "Vui lòng bật GPS",
        ));
        return;
      }

      // 2. Kiểm tra quyền
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

      // 3. Lấy tọa độ hiện tại
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      print("📍 GPS: ${position.latitude}, ${position.longitude}");

      // 4. Reverse geocoding → tên địa chỉ
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
        print("⚠️ Geocoding error (dùng tọa độ thô): $geoError");
      }

      final newState = current.copyWith(
        isLoadingLocation: false,
        currentLocation: addressText,
        pickupPlaceId: "didGetFromGPS",
        pickupCoords: GoongLocationCoords(
          lat: position.latitude,
          lng: position.longitude,
        ),
      );
      emit(newState);
      _checkAndFetchVehicles(newState);
    } catch (e, st) {
      print("❌ FetchCurrentLocation error: $e\n$st");
      emit(current.copyWith(
        isLoadingLocation: false,
        currentLocation: "Không thể lấy vị trí",
      ));
    }
  }
}
