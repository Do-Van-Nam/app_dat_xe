part of 'finding_driver_bloc.dart';

enum FindingDriverStatus { initial, searching, found, cancelled, timeout }

class FindingDriverState extends Equatable {
  const FindingDriverState({
    this.status = FindingDriverStatus.initial,
    this.pickupAddress = 'Vincom Center, 72 Lê Thánh Tôn, Q.1',
    this.destinationAddress = 'Landmark 81, Bình Thạnh',
    this.estimatedPrice = 150000,
    this.distance = 4.2,
  });

  final FindingDriverStatus status;
  final String pickupAddress;
  final String destinationAddress;
  final int estimatedPrice;
  final double distance;

  FindingDriverState copyWith({
    FindingDriverStatus? status,
    String? pickupAddress,
    String? destinationAddress,
    int? estimatedPrice,
    double? distance,
  }) {
    return FindingDriverState(
      status: status ?? this.status,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      distance: distance ?? this.distance,
    );
  }

  @override
  List<Object?> get props => [
        status,
        pickupAddress,
        destinationAddress,
        estimatedPrice,
        distance,
      ];
}
