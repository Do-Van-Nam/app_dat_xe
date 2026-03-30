import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

part 'voucher_event.dart';
part 'voucher_state.dart';

class VoucherBloc extends Bloc<VoucherEvent, VoucherState> {
  VoucherBloc() : super(VoucherInitial()) {
    on<LoadVouchersEvent>(_onLoadVouchers);
    on<ApplyPromoCodeEvent>(_onApplyPromoCode);
    on<TabChangedEvent>(_onTabChanged);
  }

  Future<void> _onLoadVouchers(
      LoadVouchersEvent event, Emitter<VoucherState> emit) async {
    emit(VoucherLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final expiring = [
        VoucherItem(
          id: "1",
          title: "Voucher Giảm 20k cho chuyến xe",
          subtitle: "CHUYẾN XE",
          expiry: "Hạn: 23:59 hôm nay",
          category: "Chuyến xe",
          icon: Icons.local_taxi,
          isExpiringSoon: true,
        ),
        VoucherItem(
          id: "2",
          title: "Voucher Miễn phí giao hàng (Freeship)",
          subtitle: "VẬN CHUYỂN",
          expiry: "Còn 4 giờ",
          category: "Vận chuyển",
          imageUrl: "https://picsum.photos/id/201/300/200",
          isExpiringSoon: true,
        ),
      ];

      final myVouchersList = [
        VoucherItem(
          id: "3",
          title: "Giảm 50% đồ ăn tối đa 30k",
          subtitle: "ẨM THỰC",
          expiry: "HSD: 30/11/2024",
          category: "Ẩm thực",
          icon: Icons.restaurant,
        ),
        VoucherItem(
          id: "4",
          title: "Đồng giá 15k toàn quốc",
          subtitle: "DI CHUYỂN",
          expiry: "HSD: 15/12/2024",
          category: "Di chuyển",
          icon: Icons.directions_bus,
        ),
        VoucherItem(
          id: "5",
          title: "Hoàn tiền 10% tối đa 100k",
          subtitle: "MUA SẮM",
          expiry: "HSD: 31/12/2024",
          category: "Mua sắm",
          icon: Icons.shopping_bag,
        ),
      ];

      emit(VoucherLoaded(
        expiringSoon: expiring,
        myVouchers: myVouchersList,
      ));
    } catch (e) {
      emit(VoucherError("Không thể tải voucher"));
    }
  }

  Future<void> _onApplyPromoCode(
      ApplyPromoCodeEvent event, Emitter<VoucherState> emit) async {
    emit(VoucherApplying());
    await Future.delayed(const Duration(seconds: 1));
    emit(VoucherApplySuccess("Áp dụng mã ${event.code} thành công!"));
  }

  void _onTabChanged(TabChangedEvent event, Emitter<VoucherState> emit) {
    if (state is VoucherLoaded) {
      final current = state as VoucherLoaded;
      emit(VoucherLoaded(
        expiringSoon: current.expiringSoon,
        myVouchers: current.myVouchers,
        selectedTabIndex: event.index,
      ));
    }
  }
}
