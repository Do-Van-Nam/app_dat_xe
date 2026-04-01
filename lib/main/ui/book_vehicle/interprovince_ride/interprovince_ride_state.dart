part of 'interprovince_ride_bloc.dart';

class InterprovinceRideState {
  final String pickupPoint;
  final String destination;
  final DateTime selectedDate;
  final TimeOfDay pickupTime;
  final int selectedVehicleType; // 0: ghép, 1: 4 chỗ, 2: 7 chỗ
  final double estimatedPrice;
  final bool isLoading;

  const InterprovinceRideState({
    this.pickupPoint = "Vincom Center, Quận 1, TP.HCM",
    this.destination = "",
    required this.selectedDate,
    required this.pickupTime,
    this.selectedVehicleType = 0,
    this.estimatedPrice = 850000,
    this.isLoading = false,
  });

  InterprovinceRideState copyWith({
    String? pickupPoint,
    String? destination,
    DateTime? selectedDate,
    TimeOfDay? pickupTime,
    int? selectedVehicleType,
    double? estimatedPrice,
    bool? isLoading,
  }) {
    return InterprovinceRideState(
      pickupPoint: pickupPoint ?? this.pickupPoint,
      destination: destination ?? this.destination,
      selectedDate: selectedDate ?? this.selectedDate,
      pickupTime: pickupTime ?? this.pickupTime,
      selectedVehicleType: selectedVehicleType ?? this.selectedVehicleType,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
