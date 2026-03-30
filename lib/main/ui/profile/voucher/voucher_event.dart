part of 'voucher_bloc.dart';

abstract class VoucherEvent {}

class LoadVouchersEvent extends VoucherEvent {}

class ApplyPromoCodeEvent extends VoucherEvent {
  final String code;
  ApplyPromoCodeEvent(this.code);
}

class TabChangedEvent extends VoucherEvent {
  final int index;
  TabChangedEvent(this.index);
}
