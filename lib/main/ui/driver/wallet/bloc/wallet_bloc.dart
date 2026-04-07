import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import './wallet_models.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(const WalletState()) {
    on<WalletLoaded>(_onLoaded);
    on<TopUpTapped>(_onTopUp);
    on<UpgradeTapped>(_onUpgrade);
    on<ViewAllTransactionsTapped>(_onViewAll);
    on<WalletIconTapped>(_onWalletIcon);
    on<NavTabChanged>(_onNavTab);
    on<SosTapped>(_onSos);
  }

  Future<void> _onLoaded(
    WalletLoaded event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(status: WalletStatus.loading));

    // Simulate network fetch
    await Future.delayed(const Duration(milliseconds: 400));

    emit(state.copyWith(
      status: WalletStatus.success,
      transactions: const [
        Transaction(
          id: 'tx1',
          title: 'Thu nhập từ cuốc xe #9921',
          time: '10:45 • 24 Th05, 2024',
          amount: 45000,
          type: TransactionType.income,
        ),
        Transaction(
          id: 'tx2',
          title: 'Khấu trừ chiết khấu',
          time: '09:15 • 24 Th05, 2024',
          amount: -12500,
          type: TransactionType.deduction,
        ),
      ],
    ));
  }

  void _onTopUp(TopUpTapped event, Emitter<WalletState> emit) {
    // Navigate to top-up screen via page listener.
  }

  void _onUpgrade(UpgradeTapped event, Emitter<WalletState> emit) {
    // Navigate to upgrade plan screen.
  }

  void _onViewAll(ViewAllTransactionsTapped event, Emitter<WalletState> emit) {
    // Navigate to full transaction history screen.
  }

  void _onWalletIcon(WalletIconTapped event, Emitter<WalletState> emit) {
    // Navigate to wallet detail screen.
  }

  void _onNavTab(NavTabChanged event, Emitter<WalletState> emit) {
    emit(state.copyWith(selectedTab: event.tab));
  }

  void _onSos(SosTapped event, Emitter<WalletState> emit) {
    // Trigger SOS flow.
  }
}
