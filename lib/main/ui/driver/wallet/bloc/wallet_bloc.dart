import 'package:demo_app/main/data/model/finance/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:demo_app/main/data/repository/finance_repository.dart';
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

    final (success, response) = await FinanceRepository().getWalletManage();

    if (success && response != null) {
      emit(state.copyWith(
        status: WalletStatus.success,
        walletManageResponse: response,
        // Optional: Update existing fields for compatibility with existing UI if needed
        income: response.wallet?.totalEarned?.toInt() ?? 0,
        creditBalance: response.wallet?.balance?.toInt() ?? 0,
      ));
    } else {
      emit(state.copyWith(
        status: WalletStatus.failure,
        errorMessage: "Không thể lấy thông tin ví",
      ));
    }
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
