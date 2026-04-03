part of 'shipping_bloc.dart';

enum ShippingServiceType { sieu_toc, sieu_rp_2h }

enum ShippingStatus { initial, loading, success, failure }

class ShippingState extends Equatable {
  const ShippingState({
    this.pickupAddress = '123 Đường Lê Lợi, Quận 1',
    this.deliveryPoints = const ['456 Đường Nguyễn Huệ, Quận 1'],
    this.returnToPickup = false,
    this.selectedService = ShippingServiceType.sieu_toc,
    this.paymentMethod = 'Tiền mặt',
    this.discountLabel = 'Giảm 30%',
    this.totalPrice = '29.000đ',
    this.estimatedDistance = '4.2 km',
    this.status = ShippingStatus.initial,
    this.errorMessage,
  });

  final String pickupAddress;
  final List<String> deliveryPoints;
  final bool returnToPickup;
  final ShippingServiceType selectedService;
  final String paymentMethod;
  final String discountLabel;
  final String totalPrice;
  final String estimatedDistance;
  final ShippingStatus status;
  final String? errorMessage;

  ShippingState copyWith({
    String? pickupAddress,
    List<String>? deliveryPoints,
    bool? returnToPickup,
    ShippingServiceType? selectedService,
    String? paymentMethod,
    String? discountLabel,
    String? totalPrice,
    String? estimatedDistance,
    ShippingStatus? status,
    String? errorMessage,
  }) {
    return ShippingState(
      pickupAddress: pickupAddress ?? this.pickupAddress,
      deliveryPoints: deliveryPoints ?? this.deliveryPoints,
      returnToPickup: returnToPickup ?? this.returnToPickup,
      selectedService: selectedService ?? this.selectedService,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      discountLabel: discountLabel ?? this.discountLabel,
      totalPrice: totalPrice ?? this.totalPrice,
      estimatedDistance: estimatedDistance ?? this.estimatedDistance,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        pickupAddress,
        deliveryPoints,
        returnToPickup,
        selectedService,
        paymentMethod,
        discountLabel,
        totalPrice,
        estimatedDistance,
        status,
        errorMessage,
      ];
}
