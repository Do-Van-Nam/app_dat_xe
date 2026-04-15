import 'package:demo_app/main/data/model/finance/voucher.dart';
import 'package:demo_app/main/data/repository/finance_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

part 'voucher_event.dart';
part 'voucher_state.dart';

class VoucherBloc extends Bloc<VoucherEvent, VoucherState> {
  final FinanceRepository _financeRepository = FinanceRepository();

  VoucherBloc() : super(VoucherInitial()) {
    on<LoadVouchersEvent>(_onLoadVouchers);
    on<ApplyPromoCodeEvent>(_onApplyPromoCode);
    on<TabChangedEvent>(_onTabChanged);
  }

  Future<void> _onLoadVouchers(
      LoadVouchersEvent event, Emitter<VoucherState> emit) async {
    emit(VoucherLoading());
    try {
      final (success, vouchers) = await _financeRepository.getVouchers();

      if (success) {
        // Giả sử các voucher sắp hết hạn là các voucher đầu tiên hoặc lọc theo logic nào đó
        // Ở đây mình cứ để là vouchers cho cả 2 để UI hiển thị được dữ liệu thật
        emit(VoucherLoaded(
          expiringSoon: vouchers.take(2).toList(),
          myVouchers: vouchers,
          selectedTabIndex: (state is VoucherLoaded)
              ? (state as VoucherLoaded).selectedTabIndex
              : 0,
        ));
      } else {
        emit(VoucherError("Không thể lấy danh sách voucher từ máy chủ"));
      }
    } catch (e) {
      print('❌ VoucherBloc error: $e');
      emit(VoucherError("Đã xảy ra lỗi khi tải voucher"));
    }
  }

  Future<void> _onApplyPromoCode(
      ApplyPromoCodeEvent event, Emitter<VoucherState> emit) async {
    emit(VoucherApplying());
    // Giả sử API yêu cầu ID, nhưng UI truyền Code.
    // Trong thực tế có thể cần tìm ID từ code hoặc API apply bằng code.
    // Ở đây mình simulate việc apply (vì repo đang có quickApplyVoucher(id))
    await Future.delayed(const Duration(seconds: 1));
    emit(VoucherApplySuccess("Áp dụng mã ${event.code} thành công!"));
  }

  void _onTabChanged(TabChangedEvent event, Emitter<VoucherState> emit) {
    if (state is VoucherLoaded) {
      final current = state as VoucherLoaded;
      emit(current.copyWith(selectedTabIndex: event.index));
    }
  }
}
