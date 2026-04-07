part of 'topup_bloc.dart';

abstract class TopUpEvent extends Equatable {
  const TopUpEvent();
  @override
  List<Object?> get props => [];
}

/// Page loads.
class TopUpInitialized extends TopUpEvent {
  const TopUpInitialized();
}

/// User taps a quick-amount chip.
class QuickAmountSelected extends TopUpEvent {
  final int amount; // VND
  const QuickAmountSelected(this.amount);
  @override
  List<Object?> get props => [amount];
}

/// User edits the amount field manually.
class AmountChanged extends TopUpEvent {
  final String raw; // digits only
  const AmountChanged(this.raw);
  @override
  List<Object?> get props => [raw];
}

/// User selects a payment method (e-wallet radio).
class PaymentMethodSelected extends TopUpEvent {
  final PaymentMethodId methodId;
  const PaymentMethodSelected(this.methodId);
  @override
  List<Object?> get props => [methodId];
}

/// User taps a bank row (arrow → navigates).
class BankMethodTapped extends TopUpEvent {
  final PaymentMethodId methodId;
  const BankMethodTapped(this.methodId);
  @override
  List<Object?> get props => [methodId];
}

/// User taps "Thay đổi".
class ChangeMethodTapped extends TopUpEvent {
  const ChangeMethodTapped();
}

/// User confirms top-up.
class TopUpConfirmed extends TopUpEvent {
  const TopUpConfirmed();
}
