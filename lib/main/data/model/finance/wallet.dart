import 'package:demo_app/main/utils/utility_fuctions.dart';

class WalletManageResponse {
  final DriverStatus? driverStatus;
  final Wallet? wallet;
  final List<Transaction>? recentTransactions;

  WalletManageResponse({
    this.driverStatus,
    this.wallet,
    this.recentTransactions,
  });

  factory WalletManageResponse.fromJson(Map<String, dynamic> json) {
    return WalletManageResponse(
      driverStatus: json['driver_status'] != null
          ? DriverStatus.fromJson(json['driver_status'])
          : null,
      wallet: json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null,
      recentTransactions: json['recent_transactions'] != null
          ? (json['recent_transactions'] as List)
              .map((i) => Transaction.fromJson(i))
              .toList()
          : null,
    );
  }
}

class DriverStatus {
  final bool? isOnline;
  final String? label;

  DriverStatus({
    this.isOnline,
    this.label,
  });

  factory DriverStatus.fromJson(Map<String, dynamic> json) {
    return DriverStatus(
      isOnline: json['is_online'] as bool?,
      label: json['label'] as String?,
    );
  }
}

class Wallet {
  final String? id;
  final num? balance;
  final num? totalEarned;
  final num? totalWithdrawn;

  Wallet({
    this.id,
    this.balance,
    this.totalEarned,
    this.totalWithdrawn,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id']?.toString(),
      balance: parseNum(json['balance']),
      totalEarned: parseNum(json['total_earned']),
      totalWithdrawn: parseNum(json['total_withdrawn']),
    );
  }
}

class Transaction {
  final String? id;
  final num? amount;
  final int? type;
  final String? typeLabel;
  final String? symbol;
  final num? balanceBefore;
  final num? balanceAfter;
  final String? description;
  final String? referenceType;
  final String? referenceId;
  final String? createdAt;
  final String? status;

  Transaction({
    this.id,
    this.amount,
    this.type,
    this.typeLabel,
    this.symbol,
    this.balanceBefore,
    this.balanceAfter,
    this.description,
    this.referenceType,
    this.referenceId,
    this.createdAt,
    this.status,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id']?.toString(),
      amount: parseNum(json['amount']),
      type: json['type'] as int?,
      typeLabel: json['type_label'] as String?,
      symbol: json['symbol'] as String?,
      balanceBefore: parseNum(json['balance_before']),
      balanceAfter: parseNum(json['balance_after']),
      description: json['description'] as String?,
      referenceType: json['reference_type'] as String?,
      referenceId: json['reference_id']?.toString(),
      createdAt: json['created_at'] as String?,
      status: json['status'] as String?,
    );
  }
}
