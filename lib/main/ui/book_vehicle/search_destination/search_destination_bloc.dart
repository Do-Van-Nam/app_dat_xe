import 'dart:ui';

import 'package:demo_app/main/data/model/goong/place_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

import 'package:demo_app/main/data/model/goong/location.dart';
import 'package:demo_app/main/data/repository/goong_repository.dart';

part 'search_destination_event.dart';
part 'search_destination_state.dart';

class SearchDestinationBloc
    extends Bloc<SearchDestinationEvent, SearchDestinationState> {
  SearchDestinationBloc() : super(SearchDestinationInitial()) {
    on<LoadSearchDataEvent>(_onLoadData);
    on<SearchQueryChangedEvent>(_onSearchQueryChanged);
    on<SaveLocationEvent>(_onSaveLocation);
    on<FetchCurrentLocationEvent>(_onFetchCurrentLocation);
    // on<SavePickupLocationEvent>(_onSavePickupLocation);
    // on<SaveDestinationLocationEvent>(_onSaveDestinationLocation);
    on<SavePickupPlaceIdEvent>(_onSavePickupPlaceId);
    on<SaveDestinationPlaceIdEvent>(_onSaveDestinationPlaceId);
    on<SubmitSearchEvent>(_onSubmitSearch);
  }

  Future<void> _onLoadData(
      LoadSearchDataEvent event, Emitter<SearchDestinationState> emit) async {
    emit(SearchDestinationLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 700));

      final popular = [
        PopularDestination(
          id: "1",
          name: "Lotte Mall West Lake Hà Nội",
          distance: "6km",
          address: "272 Võ Chí Công, P.Phú Thượng, Q.Tây Hồ, Hà Nội",
        ),
        PopularDestination(
          id: "2",
          name: "Quảng trường Ba Đình",
          distance: "6,5km",
          address: "Hùng Vương, P.Diện Biên, Q.Ba Đình, Hà Nội",
        ),
        PopularDestination(
          id: "3",
          name: "Văn Miếu Quốc Tử Giám",
          distance: "7km",
          address: "58 Quốc Tử Giám, P.Văn Miếu, Q.Đống Đa, Hà Nội",
        ),
        PopularDestination(
          id: "4",
          name: "Di Tích Nhà Tù Hỏa Lò",
          distance: "8km",
          address: "1 Hỏa Lò, P.Trần Hưng Đạo, Q.Hoàn Kiếm, Hà Nội",
        ),
      ];

      final recent = [
        RecentSearch(
          id: "r1",
          name: "Bitexco Financial Tower",
          address: "2 Hải Triều, Bến Nghé, Quận 1",
        ),
        RecentSearch(
          id: "r2",
          name: "Landmark 81",
          address: "720A Điện Biên Phủ, Phường 22, Bình Thạnh",
        ),
      ];

      emit(SearchDestinationLoaded(
        popularDestinations: popular,
        recentSearches: recent,
        pickupLocation: null,
        destinationLocation: null,
      ));
    } catch (e) {
      emit(SearchDestinationError("Không thể tải dữ liệu"));
    }
  }

  Future<void> _onSearchQueryChanged(SearchQueryChangedEvent event,
      Emitter<SearchDestinationState> emit) async {
    if (state is! SearchDestinationLoaded) return;
    final currentState = state as SearchDestinationLoaded;

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

  void _onSaveLocation(
      SaveLocationEvent event, Emitter<SearchDestinationState> emit) {
    // TODO: Lưu vào danh sách yêu thích
    print("Saved location: ${event.locationId}");
  }

  // ============================================================
  // Lấy vị trí GPS hiện tại + Reverse Geocoding → địa chỉ text
  // ============================================================

  Future<void> _onFetchCurrentLocation(FetchCurrentLocationEvent event,
      Emitter<SearchDestinationState> emit) async {
    if (state is! SearchDestinationLoaded) return;
    final current = state as SearchDestinationLoaded;

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
      SavePickupLocationEvent event, Emitter<SearchDestinationState> emit) {
    emit((state as SearchDestinationLoaded).copyWith(
      pickupLocation: event.pickupLocation,
    ));
  }

  void _onSaveDestinationLocation(SaveDestinationLocationEvent event,
      Emitter<SearchDestinationState> emit) {
    emit((state as SearchDestinationLoaded).copyWith(
      destinationLocation: event.destinationLocation,
    ));
  }

  void _onSavePickupPlaceId(
      SavePickupPlaceIdEvent event, Emitter<SearchDestinationState> emit) {
    emit((state as SearchDestinationLoaded).copyWith(
      pickupPlaceId: event.pickupPlaceId,
    ));
  }

  void _onSaveDestinationPlaceId(
      SaveDestinationPlaceIdEvent event, Emitter<SearchDestinationState> emit) {
    emit((state as SearchDestinationLoaded).copyWith(
      destinationPlaceId: event.destinationPlaceId,
    ));
  }

  Future<void> _onSubmitSearch(
      SubmitSearchEvent event, Emitter<SearchDestinationState> emit) async {
    if (state is! SearchDestinationLoaded) return;
    final current = state as SearchDestinationLoaded;
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
      emit(current.copyWith(
        submitMessage: "Vui lòng nhập địa chỉ hợp lệ",
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
