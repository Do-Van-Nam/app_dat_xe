part of 'waiting_driver_bloc.dart';

enum WaitingDriverStatus {
  searching, // đang tìm tài xế
  found, // đã tìm được tài xế
  cancelled, // người dùng hủy
  error,
}

class WaitingDriverState extends Equatable {
  const WaitingDriverState({
    this.status = WaitingDriverStatus.searching,
    this.scheduleValue = 'Thứ Năm, 24 Tháng 10 • 08:30 AM',
    this.pickupAddress = 'Landmark 81, Phường 22, Bình Thạnh, TP. Hồ Chí Minh',
    this.destinationAddress = 'Sân bay Quốc tế Tân Sơn Nhất, Quận Tân Bình',
    this.isCancelLoading = false,
    this.errorMessage,
  });

  final WaitingDriverStatus status;
  final String scheduleValue;
  final String pickupAddress;
  final String destinationAddress;
  final bool isCancelLoading;
  final String? errorMessage;

  WaitingDriverState copyWith({
    WaitingDriverStatus? status,
    String? scheduleValue,
    String? pickupAddress,
    String? destinationAddress,
    bool? isCancelLoading,
    String? errorMessage,
  }) {
    return WaitingDriverState(
      status: status ?? this.status,
      scheduleValue: scheduleValue ?? this.scheduleValue,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      isCancelLoading: isCancelLoading ?? this.isCancelLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        scheduleValue,
        pickupAddress,
        destinationAddress,
        isCancelLoading,
        errorMessage,
      ];
}
