part of 'expense_management_bloc.dart';

@immutable
sealed class ExpenseManagementState {}

final class ExpenseManagementInitial extends ExpenseManagementState {}

final class ExpenseManagementLoading extends ExpenseManagementState {}

final class ExpenseManagementLoaded extends ExpenseManagementState {
  final int totalExpense;
  final double growthPercent;
  final List<CategorySpending> categories;
  final List<Transaction> recentTransactions;
  final int selectedPeriodIndex;

  ExpenseManagementLoaded({
    required this.totalExpense,
    required this.growthPercent,
    required this.categories,
    required this.recentTransactions,
    this.selectedPeriodIndex = 0,
  });
}

final class ExpenseManagementError extends ExpenseManagementState {
  final String message;
  ExpenseManagementError(this.message);
}

// Models
class CategorySpending {
  final String name;
  final double percent;
  final Color color;

  CategorySpending({
    required this.name,
    required this.percent,
    required this.color,
  });
}

class Transaction {
  final String title;
  final String time;
  final int amount;
  final String status;
  final IconData icon;
  final Color iconBackgroundColor;

  Transaction({
    required this.title,
    required this.time,
    required this.amount,
    required this.status,
    required this.icon,
    required this.iconBackgroundColor,
  });
}
