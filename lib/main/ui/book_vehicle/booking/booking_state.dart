part of 'booking_bloc.dart';

@immutable
sealed class BookingState {}

final class BookingInitial extends BookingState {}

final class BookingLoading extends BookingState {}

final class BookingLoaded extends BookingState {
  final String pickupAddress;
  final String destinationAddress;
  final String? rideId;
  final Price? price;
  final List<VehicleOption> vehicles;
  final String selectedVehicleId;
  final String? promoCode;
  final int totalAmount;
  final String currentLocation;
  final bool isLoadingLocation;
  // Cho kết quả tìm kiếm Goong Maps
  final List<GoongLocation> searchResults;
  final bool isSearching;
  final GoongPlaceDetail? pickupLocation;
  final GoongPlaceDetail? destinationLocation;
  final String? pickupPlaceId;
  final String? destinationPlaceId;
  final UniqueError? submitMessage;

  BookingLoaded({
    required this.pickupAddress,
    required this.destinationAddress,
    required this.vehicles,
    this.selectedVehicleId = "1",
    this.promoCode,
    required this.totalAmount,
    this.rideId,
    this.price,
    this.currentLocation = '',
    this.isLoadingLocation = false,
    this.searchResults = const [],
    this.isSearching = false,
    this.pickupLocation,
    this.destinationLocation,
    this.pickupPlaceId,
    this.destinationPlaceId,
    this.submitMessage,
  });

  BookingLoaded copyWith({
    String? pickupAddress,
    String? destinationAddress,
    String? rideId,
    Price? price,
    List<VehicleOption>? vehicles,
    String? selectedVehicleId,
    String? promoCode,
    int? totalAmount,
    String? currentLocation,
    bool? isLoadingLocation,
    List<GoongLocation>? searchResults,
    bool? isSearching,
    GoongPlaceDetail? pickupLocation,
    GoongPlaceDetail? destinationLocation,
    String? pickupPlaceId,
    String? destinationPlaceId,
    UniqueError? submitMessage,
  }) {
    return BookingLoaded(
      pickupAddress: pickupAddress ?? this.pickupAddress,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      vehicles: vehicles ?? this.vehicles,
      selectedVehicleId: selectedVehicleId ?? this.selectedVehicleId,
      promoCode: promoCode ?? this.promoCode,
      totalAmount: totalAmount ?? this.totalAmount,
      rideId: rideId ?? this.rideId,
      price: price ?? this.price,
      currentLocation: currentLocation ?? this.currentLocation,
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      pickupPlaceId: pickupPlaceId ?? this.pickupPlaceId,
      destinationPlaceId: destinationPlaceId ?? this.destinationPlaceId,
      submitMessage: submitMessage ?? this.submitMessage,
    );
  }
}

final class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}

// Model
class VehicleOption {
  final String id;
  final String name;
  final int price;
  final String time;
  final String tag; // TIẾT KIỆM, PHỔ BIẾN, GIA ĐÌNH
  final String icon;
  final Color? tagColor;

  VehicleOption({
    required this.id,
    required this.name,
    required this.price,
    required this.time,
    required this.tag,
    required this.icon,
    this.tagColor,
  });
}
