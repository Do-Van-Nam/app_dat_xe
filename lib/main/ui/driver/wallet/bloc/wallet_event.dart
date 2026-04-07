part of 'wallet_bloc.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();
  @override
  List<Object?> get props => [];
}

/// Page loads — fetch wallet data.
class WalletLoaded extends WalletEvent {
  const WalletLoaded();
}

/// User taps "Nạp tiền".
class TopUpTapped extends WalletEvent {
  const TopUpTapped();
}

/// User taps "Nâng cấp ngay" on promo banner.
class UpgradeTapped extends WalletEvent {
  const UpgradeTapped();
}

/// User taps "Xem tất cả" transaction history.
class ViewAllTransactionsTapped extends WalletEvent {
  const ViewAllTransactionsTapped();
}

/// Wallet icon tapped — open wallet detail.
class WalletIconTapped extends WalletEvent {
  const WalletIconTapped();
}

/// Bottom nav tab changed.
class NavTabChanged extends WalletEvent {
  final NavTab tab;
  const NavTabChanged(this.tab);
  @override
  List<Object?> get props => [tab];
}

/// SOS tapped.
class SosTapped extends WalletEvent {
  const SosTapped();
}
