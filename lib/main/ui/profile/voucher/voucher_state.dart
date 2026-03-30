part of 'voucher_bloc.dart';

@immutable
sealed class VoucherState {}

final class VoucherInitial extends VoucherState {}

final class VoucherLoading extends VoucherState {}

final class VoucherLoaded extends VoucherState {
  final List<VoucherItem> expiringSoon;
  final List<VoucherItem> myVouchers;
  final int selectedTabIndex;

  VoucherLoaded({
    required this.expiringSoon,
    required this.myVouchers,
    this.selectedTabIndex = 0,
  });
}

final class VoucherApplying extends VoucherState {}

final class VoucherApplySuccess extends VoucherState {
  final String message;
  VoucherApplySuccess(this.message);
}

final class VoucherError extends VoucherState {
  final String message;
  VoucherError(this.message);
}

// Model Voucher
class VoucherItem {
  final String id;
  final String title;
  final String subtitle;
  final String? expiry;
  final String category;
  final IconData? icon;
  final String? imageUrl;
  final bool isExpiringSoon;

  VoucherItem({
    required this.id,
    required this.title,
    required this.subtitle,
    this.expiry,
    required this.category,
    this.icon,
    this.imageUrl,
    this.isExpiringSoon = false,
  });
}
