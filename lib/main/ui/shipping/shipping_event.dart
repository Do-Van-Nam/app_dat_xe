part of 'shipping_bloc.dart';

abstract class ShippingEvent extends Equatable {
  const ShippingEvent();

  @override
  List<Object?> get props => [];
}

/// User taps "Thêm điểm giao hàng".
class ShippingAddDeliveryPoint extends ShippingEvent {
  const ShippingAddDeliveryPoint(this.address);
  final String address;

  @override
  List<Object?> get props => [address];
}

/// User removes a delivery point by index.
class ShippingRemoveDeliveryPoint extends ShippingEvent {
  const ShippingRemoveDeliveryPoint(this.index);
  final int index;

  @override
  List<Object?> get props => [index];
}

/// User toggles "Quay lại điểm lấy hàng".
class ShippingReturnToPickupToggled extends ShippingEvent {
  const ShippingReturnToPickupToggled();
}

/// User selects a service package.
class ShippingServiceSelected extends ShippingEvent {
  const ShippingServiceSelected(this.service);
  final ShippingServiceType service;

  @override
  List<Object?> get props => [service];
}

/// User taps payment method row to change payment.
class ShippingPaymentMethodTapped extends ShippingEvent {
  const ShippingPaymentMethodTapped();
}

/// User taps "Thêm thông tin đơn hàng".
class ShippingAddInfoTapped extends ShippingEvent {
  const ShippingAddInfoTapped();
}

/// User taps schedule icon (book later).
class ShippingScheduleTapped extends ShippingEvent {
  const ShippingScheduleTapped();
}

/// User taps "ĐẶT GIAO NGAY".
class ShippingOrderNowTapped extends ShippingEvent {
  const ShippingOrderNowTapped();
}
