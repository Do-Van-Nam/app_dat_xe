import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/data/repository/finance_repository.dart';
import 'package:demo_app/main/data/model/finance/package.dart';
import '../membership_models.dart';

part 'membership_event.dart';
part 'membership_state.dart';

class MembershipBloc extends Bloc<MembershipEvent, MembershipState> {
  MembershipBloc() : super(const MembershipState()) {
    on<MembershipLoaded>(_onLoaded);
    on<PackageSelected>(_onPackageSelected);
    on<BenefitDetailTapped>(_onBenefitDetail);
    on<RegisterTapped>(_onRegister);
    on<BackTapped>(_onBack);
  }

  Future<void> _onLoaded(
    MembershipLoaded event,
    Emitter<MembershipState> emit,
  ) async {
    emit(state.copyWith(status: MembershipStatus.loading));

    final (success, packages) =
        await FinanceRepository().getSubscriptionPackages();

    emit(state.copyWith(
      status: success ? MembershipStatus.success : MembershipStatus.failure,
      packages: packages,
      selectedPackageId: packages.isNotEmpty ? packages.first.id : null,
    ));
  }

  void _onPackageSelected(
      PackageSelected event, Emitter<MembershipState> emit) {
    emit(state.copyWith(selectedPackageId: event.packageId));
  }

  void _onBenefitDetail(
      BenefitDetailTapped event, Emitter<MembershipState> emit) {
    // Navigate to benefit detail screen from page listener.
  }

  Future<void> _onRegister(
    RegisterTapped event,
    Emitter<MembershipState> emit,
  ) async {
    emit(state.copyWith(status: MembershipStatus.registering));
    await Future.delayed(const Duration(milliseconds: 800));
    emit(state.copyWith(status: MembershipStatus.registered));
  }

  void _onBack(BackTapped event, Emitter<MembershipState> emit) {
    // Handled by page (Navigator.pop).
  }
}
