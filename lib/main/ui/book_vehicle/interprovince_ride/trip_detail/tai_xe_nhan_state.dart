part of 'tai_xe_nhan_bloc.dart';

enum TripDetailStatus { active, cancelling, cancelled, error }

class DriverInfo extends Equatable {
  const DriverInfo({
    required this.name,
    required this.rating,
    required this.tripCount,
    required this.licensePlate,
    required this.carModel,
    required this.carNote,
    required this.avatarUrl,
    this.isVerified = true,
  });

  final String name;
  final String rating;
  final String tripCount;
  final String licensePlate;
  final String carModel;
  final String carNote;
  final String avatarUrl;
  final bool isVerified;

  @override
  List<Object?> get props => [
        name,
        rating,
        tripCount,
        licensePlate,
        carModel,
        carNote,
        avatarUrl,
        isVerified,
      ];
}

class TripInfo extends Equatable {
  const TripInfo({
    required this.pickupAddress,
    required this.pickupTime,
    required this.destinationAddress,
    required this.destinationETA,
    required this.totalPrice,
    required this.paymentMethod,
  });

  final String pickupAddress;
  final String pickupTime;
  final String destinationAddress;
  final String destinationETA;
  final String totalPrice;
  final String paymentMethod;

  @override
  List<Object?> get props => [
        pickupAddress,
        pickupTime,
        destinationAddress,
        destinationETA,
        totalPrice,
        paymentMethod,
      ];
}

class TripDetailState extends Equatable {
  const TripDetailState({
    this.status = TripDetailStatus.active,
    this.driver = const DriverInfo(
      name: 'Nguyễn Minh Tuấn',
      rating: '4.9',
      tripCount: '2,450 chuyến',
      licensePlate: '29A - 888.99',
      carModel: 'Toyota Camry 2023',
      carNote:
          '"Vui lòng liên hệ với tài xế để xác nhận lại thời gian và địa điểm"',
      avatarUrl: '',
    ),
    this.trip = const TripInfo(
      pickupAddress: 'Số 123, Đường Lê Lợi, Quận 1, TP.HCM',
      pickupTime: 'Hôm nay, 14:30',
      destinationAddress: 'Sân bay Tân Sơn Nhất, Ga Quốc Nội',
      destinationETA: 'Dự kiến đến: 15:15',
      totalPrice: '245.000đ',
      paymentMethod: 'Ví điện tử',
    ),
    this.errorMessage,
  });

  final TripDetailStatus status;
  final DriverInfo driver;
  final TripInfo trip;
  final String? errorMessage;

  TripDetailState copyWith({
    TripDetailStatus? status,
    DriverInfo? driver,
    TripInfo? trip,
    String? errorMessage,
  }) {
    return TripDetailState(
      status: status ?? this.status,
      driver: driver ?? this.driver,
      trip: trip ?? this.trip,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, driver, trip, errorMessage];
}
