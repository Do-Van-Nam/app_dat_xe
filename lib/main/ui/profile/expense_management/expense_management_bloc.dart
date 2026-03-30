import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

part 'expense_management_event.dart';
part 'expense_management_state.dart';

class ExpenseManagementBloc
    extends Bloc<ExpenseManagementEvent, ExpenseManagementState> {
  ExpenseManagementBloc() : super(ExpenseManagementInitial()) {
    on<LoadExpenseDataEvent>(_onLoadData);
    on<ChangePeriodEvent>(_onChangePeriod);
  }

  Future<void> _onLoadData(
      LoadExpenseDataEvent event, Emitter<ExpenseManagementState> emit) async {
    emit(ExpenseManagementLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final categories = [
        CategorySpending(name: "Đồ ăn", percent: 45, color: Colors.blue),
        CategorySpending(name: "Đặt xe", percent: 40, color: Colors.blue),
        CategorySpending(name: "Giao hàng", percent: 15, color: Colors.orange),
      ];

      final transactions = [
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
        Transaction(
          title: "Giao hàng",
          time: "Hôm qua, 17:30",
          amount: -150000,
          status: "THÀNH CÔNG",
          icon: Icons.inventory_2,
          iconBackgroundColor: Colors.orange[100]!,
        ),
        Transaction(
          title: "Phở Thìn Lò Đúc",
          time: "Hôm qua, 12:00",
          amount: -65000,
          status: "THÀNH CÔNG",
          icon: Icons.restaurant,
          iconBackgroundColor: Colors.blue[100]!,
        ),
      ];

      emit(ExpenseManagementLoaded(
        totalExpense: 1500000,
        growthPercent: 5.0,
        categories: categories,
        recentTransactions: transactions,
      ));
    } catch (e) {
      emit(ExpenseManagementError("Không thể tải dữ liệu chi tiêu"));
    }
  }

  void _onChangePeriod(
      ChangePeriodEvent event, Emitter<ExpenseManagementState> emit) {
    if (state is ExpenseManagementLoaded) {
      final current = state as ExpenseManagementLoaded;
      emit(ExpenseManagementLoaded(
        totalExpense: current.totalExpense,
        growthPercent: current.growthPercent,
        categories: current.categories,
        recentTransactions: current.recentTransactions,
        selectedPeriodIndex: event.tabIndex,
      ));
    }
  }
}
