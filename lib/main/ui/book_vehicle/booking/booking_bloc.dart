import 'dart:ffi';

import 'package:demo_app/main/data/model/goong/location.dart';
import 'package:demo_app/main/data/model/goong/place_detail.dart';
import 'package:demo_app/main/data/model/ride/price.dart';
import 'package:demo_app/main/data/model/ride/vehicle.dart';
import 'package:demo_app/main/data/model/unique_error.dart';
import 'package:demo_app/main/data/repository/goong_repository.dart';
import 'package:demo_app/main/data/repository/ride_repository.dart';
import 'package:demo_app/main/data/service/socket_service/driver_socket_service.dart';
// import 'package:demo_app/main/data/service/socket_service/user_socket_service.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:demo_app/res/app_images.dart';
import 'package:demo_app/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GoongPlaceDetail pickUp;
  final GoongPlaceDetail dropOff;
  BookingBloc(this.pickUp, this.dropOff) : super(BookingInitial()) {
    on<LoadBookingOptionsEvent>(_onLoadOptions);
    on<SelectVehicleEvent>(_onSelectVehicle);

    // Các event được thêm mới gọi API
    on<CreateRideEvent>(_onCreateRide);
    on<SaveIdEvent>(_onSaveId);
    on<GetVehiclesEvent>(_onGetVehicles);
    on<GetPriceEvent>(_onGetPrice);
    on<ApplyPromoCodeEvent>(_onApplyPromoCode);
    on<UnApplyPromoCodeEvent>(_onUnApplyPromoCode);
    on<LoadInitialBookingData>(_onLoadInitialBookingData);
    on<ConfirmRideEvent>(_onConfirmRide);
    on<CancelRideEvent>(_onCancelRide);
    on<SearchQueryChangedEvent>(_onSearchQueryChanged);
    on<SaveLocationEvent>(_onSaveLocation);
    on<FetchCurrentLocationEvent>(_onFetchCurrentLocation);
    // on<SavePickupLocationEvent>(_onSavePickupLocation);
    // on<SaveDestinationLocationEvent>(_onSaveDestinationLocation);
    on<SavePickupPlaceIdEvent>(_onSavePickupPlaceId);
    on<SaveDestinationPlaceIdEvent>(_onSaveDestinationPlaceId);
    on<SubmitSearchEvent>(_onSubmitSearch);
  }

  Future<void> _onLoadInitialBookingData(
      LoadInitialBookingData event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    await _onLoadOptions(LoadBookingOptionsEvent(), emit);
    try {
      print("bat dau load");
      // Gọi tuần tự để tránh race condition ghi đè state lẫn nhau
      await _onCreateRide(CreateRideEvent(event.request), emit);
      await _onGetVehicles(GetVehiclesEvent(event.request), emit);
      await _onGetPrice(GetPriceEvent(event.request), emit);
      // await _onSaveId(SaveIdEvent(pickupPlaceId:event.request.pickupPlaceId??"", destinationPlaceId: event.request.destinationPlaceId??""), emit);

      print("ket thuc load");
    } catch (e) {
      print("loi load: $e");
    }
  }

  Future<void> _onSaveId(SaveIdEvent event, Emitter<BookingState> emit) async {
    if (state is! BookingLoaded) return;
    final current = state as BookingLoaded;
    print("pickupPlaceId KHI KHOI TAO: ${event.pickupPlaceId}");
    print("destinationPlaceId KHI KHOI TAO: ${event.destinationPlaceId}");
    emit(current.copyWith(
      pickupPlaceId: event.pickupPlaceId,
      destinationPlaceId: event.destinationPlaceId,
    ));
  }

  Future<void> _onLoadOptions(
      LoadBookingOptionsEvent event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final vehicles = [
        VehicleOption(
          id: "1",
          name: "Xe máy",
          price: 12000,
          time: "3p",
          tag: "TIẾT KIỆM",
          icon: AppImages.icBike2,
          tagColor: Colors.green,
        ),
        VehicleOption(
          id: "2",
          name: "Ô tô 4 chỗ",
          price: 45000,
          time: "5p",
          tag: "PHỔ BIẾN",
          icon: AppImages.icCar,
          tagColor: Colors.blue,
        ),
        VehicleOption(
          id: "3",
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
              .copyWith(vehicleType: int.tryParse(selectedVehicle.id) ?? 1)),
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
      emit(current.copyWith(
        rideId: ride.id?.toString(),
        pickupAddress: ride.pickupAddress,
        destinationAddress: ride.destinationAddress,
        pickupLocation: pickUp,
        destinationLocation: dropOff,
        pickupPlaceId: pickUp.placeId,
        destinationPlaceId: dropOff.placeId,
      ));
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
      print("list vehicle lay thanh cong ${list.length}");
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

  Future<void> _onConfirmRide(
      ConfirmRideEvent event, Emitter<BookingState> emit) async {
    if (state is! BookingLoaded) return;
    BookingLoaded current = state as BookingLoaded;

    String? rId = current.rideId;
    if (rId == null) {
      return;
    }

    final (success, ride) =
        await RideRepository().confirmRide(rId, event.expectedPrice);

    if (success) {
      // luu chuyen da dat vao
      await SharePreferenceUtil.saveCurrentRide(ride);
      event.onSuccess(PATH_TRACKING, ride);
      print(
          "tai booking bloc sau khi goi api confirm dat chuyen bat dau join ride $rId");
      // UserSocketService().joinRide(rId);
      DriverSocketService().joinRide(rId);
    }
  }

  Future<void> _onCancelRide(
      CancelRideEvent event, Emitter<BookingState> emit) async {
    if (state is! BookingLoaded) return;
    BookingLoaded current = state as BookingLoaded;

    String? rId = current.rideId;
    if (rId == null) {
      return;
    }

    final (success, ride) =
        await RideRepository().cancelRide(event.rideId, event.cancelReason);
    if (success) {
      rId = ride?.id?.toString();
      current = current.copyWith(rideId: rId);
      emit(current);
    } else {
      return;
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

  Future<void> _onSearchQueryChanged(
      SearchQueryChangedEvent event, Emitter<BookingState> emit) async {
    if (state is! BookingLoaded) return;
    final currentState = state as BookingLoaded;

    final query = event.query.trim();

    if (query.isEmpty) {
      // Nếu rỗng, hiển thị lại lịch sử/gợi ý
      emit(currentState.copyWith(
        isSearching: false,
        searchResults: [],
      ));
      return;
    }

    // Đánh dấu đang tìm kiếm
    emit(currentState.copyWith(isSearching: true));

    // Gọi API từ GoongRepository
    final goongRepo = GoongRepository();
    // TODO: Truyền thêm vĩ độ kinh độ nếu cần ưu tiên vị trí người dùng
    final (success, locations) = await goongRepo.getAutocompletePlaces(
      input: query,
      limit: 10,
    );

    if (success) {
      emit(currentState.copyWith(
        isSearching: true,
        searchResults: locations,
      ));
    } else {
      // Lỗi hoặc rỗng
      emit(currentState.copyWith(
        isSearching: true,
        searchResults: [],
      ));
    }
  }

  void _onSaveLocation(SaveLocationEvent event, Emitter<BookingState> emit) {
    // TODO: Lưu vào danh sách yêu thích
    print("Saved location: ${event.locationId}");
  }

  // ============================================================
  // Lấy vị trí GPS hiện tại + Reverse Geocoding → địa chỉ text
  // ============================================================

  Future<void> _onFetchCurrentLocation(
      FetchCurrentLocationEvent event, Emitter<BookingState> emit) async {
    if (state is! BookingLoaded) return;
    final current = state as BookingLoaded;

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
      await SharePreferenceUtil.saveCurrentPickup(GoongPlaceDetail(
        name: addressText,
        geometry: GoongGeometry(
          location: GoongLocationCoords(
            lat: position.latitude,
            lng: position.longitude,
          ),
        ),
        placeId: 'didGetFromGPS',
        formattedAddress: addressText,
      ));
      emit(current.copyWith(
        isLoadingLocation: false,
        currentLocation: addressText,
        pickupLocation: GoongPlaceDetail(
          name: addressText,
          geometry: GoongGeometry(
            location: GoongLocationCoords(
              lat: position.latitude,
              lng: position.longitude,
            ),
          ),
          placeId: 'didGetFromGPS',
          formattedAddress: addressText,
        ),
        pickupPlaceId: 'didGetFromGPS',
        pickupAddress: addressText,
      ));
    } catch (e, st) {
      print("❌ FetchCurrentLocation error: $e\n$st");
      emit(current.copyWith(
        isLoadingLocation: false,
        currentLocation: "Không thể lấy vị trí",
      ));
    }
  }

  void _onSavePickupLocation(
      SavePickupLocationEvent event, Emitter<BookingState> emit) {
    emit((state as BookingLoaded).copyWith(
      pickupLocation: event.pickupLocation,
    ));
  }

  void _onSaveDestinationLocation(
      SaveDestinationLocationEvent event, Emitter<BookingState> emit) {
    emit((state as BookingLoaded).copyWith(
      destinationLocation: event.destinationLocation,
    ));
  }

  Future<void> _onSavePickupPlaceId(
      SavePickupPlaceIdEvent event, Emitter<BookingState> emit) async {
    print("pickupPlaceId: ${event.pickupPlaceId}");
    final (success, locations) = await GoongRepository().getPlaceDetail(
      placeId: event.pickupPlaceId,
    );
    if (success && locations != null) {
      print("goi api thanh cong ,gan pickupLocation");
      await SharePreferenceUtil.saveCurrentPickup(locations);
    }
    emit((state as BookingLoaded).copyWith(
      pickupPlaceId: event.pickupPlaceId,
      pickupAddress: locations?.name,
    ));
  }

  Future<void> _onSaveDestinationPlaceId(
      SaveDestinationPlaceIdEvent event, Emitter<BookingState> emit) async {
    print("destinationPlaceId: ${event.destinationPlaceId}");
    final (success, locations) = await GoongRepository().getPlaceDetail(
      placeId: event.destinationPlaceId,
    );
    if (success && locations != null) {
      print("goi api thanh cong ,gan destinationLocation");
      await SharePreferenceUtil.saveCurrentDropOff(locations);
    }
    emit((state as BookingLoaded).copyWith(
      destinationPlaceId: event.destinationPlaceId,
      destinationAddress: locations?.name,
    ));
  }

  Future<void> _onSubmitSearch(
      SubmitSearchEvent event, Emitter<BookingState> emit) async {
    print("goi submit search");
    print("pickupPlaceId: ${event.pickupPlaceId}");
    print("destinationPlaceId: ${event.destinationPlaceId}");
    if (state is! BookingLoaded) return;
    final current = state as BookingLoaded;

    GoongPlaceDetail? pickupLocation = current.pickupLocation;
    GoongPlaceDetail? destinationLocation = current.destinationLocation;
    if (current.pickupPlaceId != null &&
        current.pickupPlaceId != 'didGetFromGPS') {
      final (success, locations) = await GoongRepository().getPlaceDetail(
        placeId: current.pickupPlaceId!,
      );
      if (success && locations != null) {
        pickupLocation = locations;
      }
    }
    if (current.destinationPlaceId != null &&
        current.destinationPlaceId != 'didGetFromGPS') {
      final (success, locations) = await GoongRepository().getPlaceDetail(
        placeId: current.destinationPlaceId!,
      );
      if (success && locations != null) {
        destinationLocation = locations;
      }
    }
    if (pickupLocation == null || destinationLocation == null) {
      print("pickupLocation: ${pickupLocation?.toJson()}");
      print("destinationLocation: ${destinationLocation?.toJson()}");
      emit(current.copyWith(
        submitMessage: UniqueError("Vui lòng nhập địa chỉ hợp lệ"),
      ));
      return;
    }
    print("pickupLocation: ${pickupLocation.name}");
    print("destinationLocation: ${destinationLocation.name}");
    print(" emit submit push booking");
    event.onSuccess(pickupLocation, destinationLocation);
    // emit(SearchDestinationSubmit(
    //   pickupLocation: pickupLocation,
    //   destinationLocation: destinationLocation,
    // ));
  }
}
