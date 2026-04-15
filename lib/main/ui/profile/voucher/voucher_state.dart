part of 'voucher_bloc.dart';

@immutable
sealed class VoucherState {}

final class VoucherInitial extends VoucherState {}

final class VoucherLoading extends VoucherState {}

final class VoucherLoaded extends VoucherState {
  final List<Voucher> expiringSoon;
  final List<Voucher> myVouchers;
  final int selectedTabIndex;

  VoucherLoaded({
    required this.expiringSoon,
    required this.myVouchers,
    this.selectedTabIndex = 0,
  });

  VoucherLoaded copyWith({
    List<Voucher>? expiringSoon,
    List<Voucher>? myVouchers,
    int? selectedTabIndex,
  }) {
    return VoucherLoaded(
      expiringSoon: expiringSoon ?? this.expiringSoon,
      myVouchers: myVouchers ?? this.myVouchers,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }
}

final class VoucherApplying extends VoucherState {}

final class VoucherApplySuccess extends VoucherState {
  final String message;
  final Voucher? voucher;
  VoucherApplySuccess(this.message, {this.voucher});
}

final class VoucherError extends VoucherState {
  final String message;
  VoucherError(this.message);
}
