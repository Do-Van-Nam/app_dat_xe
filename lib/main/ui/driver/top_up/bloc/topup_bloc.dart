import 'package:demo_app/core/app_export.dart';

import 'package:demo_app/main/data/model/finance/top_up.dart';
import 'package:demo_app/main/data/repository/finance_repository.dart';
import 'topup_models.dart';

part 'topup_event.dart';
part 'topup_state.dart';

class TopUpBloc extends Bloc<TopUpEvent, TopUpState> {
  TopUpBloc() : super(const TopUpState()) {
    on<TopUpInitialized>(_onInit);
    on<QuickAmountSelected>(_onQuickAmount);
    on<AmountChanged>(_onAmountChanged);
    on<PaymentMethodSelected>(_onMethodSelected);
    on<BankMethodTapped>(_onBankTapped);
    on<ChangeMethodTapped>(_onChangeTapped);
    on<TopUpConfirmed>(_onConfirm);
  }

  Future<void> _onInit(TopUpInitialized e, Emitter<TopUpState> emit) async {
    emit(state.copyWith(status: TopUpStatus.loading));
    await Future.delayed(const Duration(milliseconds: 200));

    final methods = [
      const PaymentMethod(
        id: PaymentMethodId.momo,
        name: 'Ví MoMo',
        group: PaymentMethodGroup.eWallet,
        iconPath: AppImages.icMomo,
        subLabel: 'Miễn phí giao dịch',
      ),
      const PaymentMethod(
        id: PaymentMethodId.zalopay,
        name: 'ZaloPay',
        group: PaymentMethodGroup.eWallet,
        iconPath: AppImages.icZaloPay,
      ),
      const PaymentMethod(
        id: PaymentMethodId.atm,
        name: 'Thẻ ATM nội địa (Napas)',
        group: PaymentMethodGroup.bank,
        iconPath: AppImages.icAtm,
        hasArrow: true,
      ),
      const PaymentMethod(
        id: PaymentMethodId.bankTransfer,
        name: 'Chuyển khoản trực tiếp',
        group: PaymentMethodGroup.bank,
        iconPath: AppImages.icBankTransfer,
        hasArrow: true,
      ),
    ];

    emit(state.copyWith(status: TopUpStatus.initial, methods: methods));
  }

  void _onQuickAmount(QuickAmountSelected e, Emitter<TopUpState> emit) {
    emit(state.copyWith(amount: e.amount));
  }

  void _onAmountChanged(AmountChanged e, Emitter<TopUpState> emit) {
    final digits = e.raw.replaceAll(RegExp(r'[^0-9]'), '');
    final parsed = int.tryParse(digits) ?? 0;
    emit(state.copyWith(amount: parsed));
  }

  void _onMethodSelected(PaymentMethodSelected e, Emitter<TopUpState> emit) {
    emit(state.copyWith(selectedMethodId: e.methodId));
  }

  void _onBankTapped(BankMethodTapped e, Emitter<TopUpState> emit) {
    // Navigate to bank method screen — handled in page listener.
  }

  void _onChangeTapped(ChangeMethodTapped e, Emitter<TopUpState> emit) {
    // Navigate to full payment method picker — handled in page listener.
  }

  Future<void> _onConfirm(TopUpConfirmed e, Emitter<TopUpState> emit) async {
    emit(state.copyWith(status: TopUpStatus.confirming));

    final paymentMethod = state.selectedMethodId.name; // e.g. "momo"
    final (success, response) = await FinanceRepository().requestTopUp(
      amount: state.amount,
      paymentMethod: paymentMethod,
    );

    if (success && response != null) {
      emit(state.copyWith(
        status: TopUpStatus.success,
        topUpResponse: response,
      ));
    } else {
      emit(state.copyWith(
        status: TopUpStatus.failure,
        errorMessage: "Yêu cầu nạp tiền không thành công",
      ));
    }
  }
}
