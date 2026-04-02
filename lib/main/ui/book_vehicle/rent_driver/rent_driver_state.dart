part of 'rent_driver_bloc.dart';

enum RentDriverStep { inputInfo, confirm }

enum RentDriverLocationStatus { locating, located, error }

class RentDriverState extends Equatable {
  const RentDriverState({
    this.currentStep = RentDriverStep.inputInfo,
    this.locationStatus = RentDriverLocationStatus.locating,
    this.pickupName = '',
    this.pickupAddress = '',
    this.destination = '',
    this.estimatedPrice,
    this.isLoading = false,
    this.errorMessage,
  });

  final RentDriverStep currentStep;
  final RentDriverLocationStatus locationStatus;
  final String pickupName;
  final String pickupAddress;
  final String destination;
  final String? estimatedPrice;
  final bool isLoading;
  final String? errorMessage;

  bool get canContinue => destination.trim().isNotEmpty;

  RentDriverState copyWith({
    RentDriverStep? currentStep,
    RentDriverLocationStatus? locationStatus,
    String? pickupName,
    String? pickupAddress,
    String? destination,
    String? estimatedPrice,
    bool? isLoading,
    String? errorMessage,
  }) {
    return RentDriverState(
      currentStep: currentStep ?? this.currentStep,
      locationStatus: locationStatus ?? this.locationStatus,
      pickupName: pickupName ?? this.pickupName,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      destination: destination ?? this.destination,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        locationStatus,
        pickupName,
        pickupAddress,
        destination,
        estimatedPrice,
        isLoading,
        errorMessage,
      ];
}
