enum NavTab { home, activity, profile }

enum TransactionType { income, deduction }

class Transaction {
  const Transaction({
    required this.id,
    required this.title,
    required this.time,
    required this.amount,
    required this.type,
  });

  final String id;
  final String title;
  final String time;
  final int amount;          // positive = income, negative = deduction (VND)
  final TransactionType type;

  bool get isIncome => type == TransactionType.income;
}
