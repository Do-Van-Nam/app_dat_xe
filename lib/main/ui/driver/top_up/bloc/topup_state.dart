part of 'topup_bloc.dart';

enum TopUpStatus { initial, loading, confirming, success, failure }

class TopUpState extends Equatable {
  const TopUpState({
    this.status = TopUpStatus.initial,
    this.amount = 0,
    this.selectedMethodId = PaymentMethodId.momo,
    this.methods = const [],
    this.quickAmounts = const [50000, 100000, 200000, 500000],
    this.errorMessage,
    this.topUpResponse,
  });

  final TopUpStatus status;
  final int amount;
  final PaymentMethodId selectedMethodId;
  final List<PaymentMethod> methods;
  final List<int> quickAmounts;
  final String? errorMessage;
  final TopUpResponse? topUpResponse;

  List<PaymentMethod> get eWalletMethods =>
      methods.where((m) => m.group == PaymentMethodGroup.eWallet).toList();

  List<PaymentMethod> get bankMethods =>
      methods.where((m) => m.group == PaymentMethodGroup.bank).toList();

  TopUpState copyWith({
    TopUpStatus? status,
    int? amount,
    PaymentMethodId? selectedMethodId,
    List<PaymentMethod>? methods,
    List<int>? quickAmounts,
    String? errorMessage,
    TopUpResponse? topUpResponse,
  }) {
    return TopUpState(
      status: status ?? this.status,
      amount: amount ?? this.amount,
      selectedMethodId: selectedMethodId ?? this.selectedMethodId,
      methods: methods ?? this.methods,
      quickAmounts: quickAmounts ?? this.quickAmounts,
      errorMessage: errorMessage,
      topUpResponse: topUpResponse ?? this.topUpResponse,
    );
  }

  @override
  List<Object?> get props => [
        status,
        amount,
        selectedMethodId,
        methods,
        quickAmounts,
        errorMessage,
        topUpResponse,
      ];
}
