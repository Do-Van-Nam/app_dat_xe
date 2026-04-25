part of 'wallet_bloc.dart';

enum WalletStatus { initial, loading, success, failure }

class WalletState extends Equatable {
  const WalletState({
    this.status = WalletStatus.initial,
    this.selectedTab = NavTab.activity,
    this.income = 1250000,
    this.creditBalance = 150000,
    this.performancePercent = 15,
    this.transactions = const [],
    this.isLowBalance = true,
    this.errorMessage,
    this.walletManageResponse,
  });

  final WalletStatus status;
  final NavTab selectedTab;
  final int income; // VND
  final int creditBalance; // VND
  final int performancePercent;
  final List<Transaction> transactions;
  final bool isLowBalance;
  final String? errorMessage;
  final WalletManageResponse? walletManageResponse;

  WalletState copyWith({
    WalletStatus? status,
    NavTab? selectedTab,
    int? income,
    int? creditBalance,
    int? performancePercent,
    List<Transaction>? transactions,
    bool? isLowBalance,
    String? errorMessage,
    WalletManageResponse? walletManageResponse,
  }) {
    return WalletState(
      status: status ?? this.status,
      selectedTab: selectedTab ?? this.selectedTab,
      income: income ?? this.income,
      creditBalance: creditBalance ?? this.creditBalance,
      performancePercent: performancePercent ?? this.performancePercent,
      transactions: transactions ?? this.transactions,
      isLowBalance: isLowBalance ?? this.isLowBalance,
      errorMessage: errorMessage,
      walletManageResponse: walletManageResponse ?? this.walletManageResponse,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedTab,
        income,
        creditBalance,
        performancePercent,
        transactions,
        isLowBalance,
        errorMessage,
        walletManageResponse,
      ];
}
