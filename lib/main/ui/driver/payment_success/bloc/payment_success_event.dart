part of 'payment_success_bloc.dart';

abstract class PaymentSuccessEvent extends Equatable {
  const PaymentSuccessEvent();

  @override
  List<Object?> get props => [];
}

/// Page loaded with transaction data.
class PaymentSuccessLoaded extends PaymentSuccessEvent {
  const PaymentSuccessLoaded({required this.transaction});
  final TransactionDetail transaction;

  @override
  List<Object?> get props => [transaction];
}

/// User taps the support card.
class PaymentSuccessSupportTapped extends PaymentSuccessEvent {
  const PaymentSuccessSupportTapped();
}

/// User taps "Quay lại trang chủ".
class PaymentSuccessGoHomeTapped extends PaymentSuccessEvent {
  const PaymentSuccessGoHomeTapped();
}

/// User taps "Xem lịch sử giao dịch".
class PaymentSuccessViewHistoryTapped extends PaymentSuccessEvent {
  const PaymentSuccessViewHistoryTapped();
}
