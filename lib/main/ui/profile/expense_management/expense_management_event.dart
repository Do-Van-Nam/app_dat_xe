part of 'expense_management_bloc.dart';

@immutable
sealed class ExpenseManagementEvent {}

class LoadExpenseDataEvent extends ExpenseManagementEvent {}

class ChangePeriodEvent extends ExpenseManagementEvent {
  final int tabIndex; // 0: Tháng này, 1: Tháng trước, 2: Tùy chỉnh
  ChangePeriodEvent(this.tabIndex);
}
