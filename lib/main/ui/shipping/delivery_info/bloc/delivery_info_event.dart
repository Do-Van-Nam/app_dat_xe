part of 'delivery_info_bloc.dart';

abstract class DeliveryInfoEvent extends Equatable {
  const DeliveryInfoEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when the user taps a weight chip.
class WeightSelected extends DeliveryInfoEvent {
  final String weight;
  const WeightSelected(this.weight);

  @override
  List<Object?> get props => [weight];
}

/// Fired when the user taps a goods-type chip.
class GoodsTypeSelected extends DeliveryInfoEvent {
  final String goodsType;
  const GoodsTypeSelected(this.goodsType);

  @override
  List<Object?> get props => [goodsType];
}

/// Fired when the receiver name field changes.
class ReceiverNameChanged extends DeliveryInfoEvent {
  final String name;
  const ReceiverNameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

/// Fired when the receiver phone field changes.
class ReceiverPhoneChanged extends DeliveryInfoEvent {
  final String phone;
  const ReceiverPhoneChanged(this.phone);

  @override
  List<Object?> get props => [phone];
}

/// Fired when the delivery note changes.
class DeliveryNoteChanged extends DeliveryInfoEvent {
  final String note;
  const DeliveryNoteChanged(this.note);

  @override
  List<Object?> get props => [note];
}

/// Fired when the user taps "Thay đổi" (change address).
class ChangeAddressTapped extends DeliveryInfoEvent {
  const ChangeAddressTapped();
}

/// Fired when the user taps "Tiếp tục" (continue).
class ContinueTapped extends DeliveryInfoEvent {
  const ContinueTapped();
}
