import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'payment_success_event.dart';
part 'payment_success_state.dart';

class PaymentSuccessBloc
    extends Bloc<PaymentSuccessEvent, PaymentSuccessState> {
  PaymentSuccessBloc({TransactionDetail? transaction})
      : super(PaymentSuccessState(
          transaction: transaction ??
              const TransactionDetail(
                txId: '#TXN123456789',
                time: '14:30, 20/05/2026',
                method: 'Ví MoMo',
                methodLogoAsset: 'assets/images/logo_momo.png',
                amount: '100.000đ',
                statusLabel: 'Hoàn thành',
              ),
        )) {
    on<PaymentSuccessLoaded>(_onLoaded);
    on<PaymentSuccessSupportTapped>(_onSupportTapped);
    on<PaymentSuccessGoHomeTapped>(_onGoHomeTapped);
    on<PaymentSuccessViewHistoryTapped>(_onViewHistoryTapped);
  }

  void _onLoaded(
      PaymentSuccessLoaded event, Emitter<PaymentSuccessState> emit) {
    emit(state.copyWith(transaction: event.transaction));
  }

  void _onSupportTapped(
      PaymentSuccessSupportTapped event, Emitter<PaymentSuccessState> emit) {
    // TODO: navigate to support / chat screen
  }

  void _onGoHomeTapped(
      PaymentSuccessGoHomeTapped event, Emitter<PaymentSuccessState> emit) {
    // Navigation handled by BlocListener in the UI layer
  }

  void _onViewHistoryTapped(PaymentSuccessViewHistoryTapped event,
      Emitter<PaymentSuccessState> emit) {
    // Navigation handled by BlocListener in the UI layer
  }
}
