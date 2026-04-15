import 'package:demo_app/main/data/model/finance/spending.dart';
import 'package:demo_app/main/data/repository/finance_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

part 'expense_management_event.dart';
part 'expense_management_state.dart';

class ExpenseManagementBloc
    extends Bloc<ExpenseManagementEvent, ExpenseManagementState> {
  final FinanceRepository _financeRepository = FinanceRepository();

  ExpenseManagementBloc() : super(ExpenseManagementInitial()) {
    on<LoadExpenseDataEvent>(_onLoadData);
    on<ChangePeriodEvent>(_onChangePeriod);
  }

  Future<void> _onLoadData(
      LoadExpenseDataEvent event, Emitter<ExpenseManagementState> emit) async {
    final int currentIndex = (state is ExpenseManagementLoaded)
        ? (state as ExpenseManagementLoaded).selectedPeriodIndex
        : 0;

    emit(ExpenseManagementLoading());
    try {
      // Map tab index to API range
      String range = 'month';
      if (currentIndex == 1)
        range = 'week'; // Giả định 1 là tuần này/tháng trước
      if (currentIndex == 2) range = 'day';

      final (success, spending) =
          await _financeRepository.getSpendingSummary(range: range);

      if (success && spending != null) {
        final categories = spending.breakdown.map((e) {
          return CategorySpending(
            name: _mapServiceName(e.service),
            percent: (spending.totalAmount > 0)
                ? double.parse(
                    (e.amount / spending.totalAmount * 100).toStringAsFixed(2))
                : 0,
            color: _getServiceColor(e.service),
          );
        }).toList();

        // Giữ lại mock transactions vì API summary chưa trả về list giao dịch chi tiết
        final transactions = _getMockTransactions();

        emit(ExpenseManagementLoaded(
          totalExpense: spending.totalAmount,
          growthPercent: 0.0, // API chưa trả về growth
          categories: categories,
          recentTransactions: transactions,
          selectedPeriodIndex: currentIndex,
        ));
      } else {
        emit(ExpenseManagementError("Không thể lấy dữ liệu từ máy chủ"));
      }
    } catch (e) {
      print('❌ ExpenseManagementBloc error: $e');
      emit(ExpenseManagementError("Không thể tải dữ liệu chi tiêu"));
    }
  }

  void _onChangePeriod(
      ChangePeriodEvent event, Emitter<ExpenseManagementState> emit) {
    // Cập nhật index và gọi load lại dữ liệu
    if (state is ExpenseManagementLoaded) {
      final current = state as ExpenseManagementLoaded;
      emit(current.copyWith(selectedPeriodIndex: event.tabIndex));
      add(LoadExpenseDataEvent());
    } else {
      // Nếu chưa load xong mà đổi thì chỉ cần ghi nhận index (hoặc ignore tùy logic)
    }
  }

  String _mapServiceName(String service) {
    switch (service.toLowerCase()) {
      case 'ride':
        return 'Đặt xe';
      case 'food':
        return 'Đồ ăn';
      case 'delivery':
        return 'Giao hàng';
      default:
        return service;
    }
  }

  Color _getServiceColor(String service) {
    switch (service.toLowerCase()) {
      case 'ride':
        return Colors.blue;
      case 'food':
        return Colors.green;
      case 'delivery':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  List<Transaction> _getMockTransactions() {
    return [
      Transaction(
        title: "The Coffee House",
        time: "Hôm nay, 09:45",
        amount: -45000,
        status: "THÀNH CÔNG",
        icon: Icons.restaurant,
        iconBackgroundColor: Colors.blue[100]!,
      ),
      Transaction(
        title: "Chuyến xe văn phòng",
        time: "Hôm nay, 08:15",
        amount: -32000,
        status: "THÀNH CÔNG",
        icon: Icons.directions_car,
        iconBackgroundColor: Colors.blue[100]!,
      ),
    ];
  }
}
