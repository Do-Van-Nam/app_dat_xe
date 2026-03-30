import 'package:demo_app/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'expense_management_bloc.dart';

class ExpenseManagementPage extends StatelessWidget {
  const ExpenseManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => ExpenseManagementBloc()..add(LoadExpenseDataEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.expenseManagement),
          leading: const BackButton(),
        ),
        body: BlocBuilder<ExpenseManagementBloc, ExpenseManagementState>(
          builder: (context, state) {
            if (state is ExpenseManagementLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ExpenseManagementError) {
              return Center(child: Text(state.message));
            }

            if (state is ExpenseManagementLoaded) {
              return RefreshIndicator(
                onRefresh: () async => context
                    .read<ExpenseManagementBloc>()
                    .add(LoadExpenseDataEvent()),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Period Tabs
                      _PeriodTabs(
                          selectedIndex: state.selectedPeriodIndex, l10n: l10n),

                      const SizedBox(height: 24),

                      // 2. Total Expense Card
                      _TotalExpenseCard(
                        total: state.totalExpense,
                        growth: state.growthPercent,
                        l10n: l10n,
                      ),

                      const SizedBox(height: 32),

                      // 3. Phân tích chi tiêu
                      _SpendingAnalysisSection(
                          categories: state.categories, l10n: l10n),

                      const SizedBox(height: 40),

                      // 4. Giao dịch gần đây
                      _RecentTransactionsHeader(l10n: l10n),
                      const SizedBox(height: 12),
                      ...state.recentTransactions.map((tx) =>
                          _TransactionItem(transaction: tx, l10n: l10n)),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

// ==================== WIDGETS DÙNG CHUNG (Sections) ====================

class _PeriodTabs extends StatelessWidget {
  final int selectedIndex;
  final AppLocalizations l10n;

  const _PeriodTabs({required this.selectedIndex, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final tabs = [l10n.thisMonth, l10n.lastMonth, l10n.custom];

    return Row(
      children: List.generate(3, (index) {
        final isSelected = index == selectedIndex;
        return Expanded(
          child: GestureDetector(
            onTap: () => context
                .read<ExpenseManagementBloc>()
                .add(ChangePeriodEvent(index)),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _TotalExpenseCard extends StatelessWidget {
  final int total;
  final double growth;
  final AppLocalizations l10n;

  const _TotalExpenseCard({
    required this.total,
    required this.growth,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTotal = total.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.totalThisMonth,
            style: const TextStyle(color: Colors.white70, fontSize: 15),
          ),
          const SizedBox(height: 12),
          Text(
            "$formattedTotal Đ",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.trending_up, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  "+$growth% ${l10n.comparedToLastMonth}",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SpendingAnalysisSection extends StatelessWidget {
  final List<CategorySpending> categories;
  final AppLocalizations l10n;

  const _SpendingAnalysisSection({
    required this.categories,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.spendingAnalysis,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.analytics_outlined, color: Colors.grey),
          ],
        ),
        const SizedBox(height: 24),

        // Donut Chart (giả lập bằng Stack + Circle)
        Center(
          child: SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 180,
                  height: 180,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 25,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation(Colors.blue),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "100%",
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                    ),
                    Text(l10n.total,
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Category List
        ...categories.map((cat) => _CategoryRow(category: cat)).toList(),
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final CategorySpending category;

  const _CategoryRow({required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: category.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(category.name),
          ),
          Text(
            "${category.percent.toInt()}%",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _RecentTransactionsHeader extends StatelessWidget {
  final AppLocalizations l10n;

  const _RecentTransactionsHeader({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l10n.recentTransactions,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          l10n.viewAll,
          style:
              const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final AppLocalizations l10n;

  const _TransactionItem({required this.transaction, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final isNegative = transaction.amount < 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: transaction.iconBackgroundColor,
          child: Icon(transaction.icon, color: Colors.blue),
        ),
        title: Text(transaction.title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(transaction.time),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "${isNegative ? '' : '+'}${transaction.amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}đ",
              style: TextStyle(
                color: isNegative ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                transaction.status,
                style: const TextStyle(
                    color: Colors.green,
                    fontSize: 11,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
