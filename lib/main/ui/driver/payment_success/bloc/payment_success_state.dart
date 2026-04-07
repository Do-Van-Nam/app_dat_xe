part of 'payment_success_bloc.dart';

class TransactionDetail extends Equatable {
  const TransactionDetail({
    required this.txId,
    required this.time,
    required this.method,
    required this.methodLogoAsset,
    required this.amount,
    required this.statusLabel,
  });

  final String txId;
  final String time;
  final String method;
  final String methodLogoAsset; // e.g. 'assets/images/logo_momo.png'
  final String amount;
  final String statusLabel;

  @override
  List<Object?> get props =>
      [txId, time, method, methodLogoAsset, amount, statusLabel];
}

class PaymentSuccessState extends Equatable {
  const PaymentSuccessState({
    this.transaction = const TransactionDetail(
      txId: '#TXN123456789',
      time: '14:30, 20/05/2026',
      method: 'Ví MoMo',
      methodLogoAsset: 'assets/images/logo_momo.png',
      amount: '100.000đ',
      statusLabel: 'Hoàn thành',
    ),
  });

  final TransactionDetail transaction;

  PaymentSuccessState copyWith({TransactionDetail? transaction}) {
    return PaymentSuccessState(transaction: transaction ?? this.transaction);
  }

  @override
  List<Object?> get props => [transaction];
}
