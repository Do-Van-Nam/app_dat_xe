import 'package:demo_app/core/app_export.dart';
import 'package:url_launcher/url_launcher.dart';

part 'waiting_approval_event.dart';
part 'waiting_approval_state.dart';

class WaitingApprovalBloc
    extends Bloc<WaitingApprovalEvent, WaitingApprovalState> {
  WaitingApprovalBloc() : super(const WaitingApprovalState()) {
    on<WaitingApprovalInitialised>(_onInitialised);
    on<WaitingApprovalStatusUpdated>(_onStatusUpdated);
    on<WaitingApprovalSupportTapped>(_onSupportTapped);
    on<WaitingApprovalGoHomeTapped>(_onGoHomeTapped);

    add(const WaitingApprovalInitialised());
  }

  void _onInitialised(
    WaitingApprovalInitialised event,
    Emitter<WaitingApprovalState> emit,
  ) {
    emit(state.copyWith(
      steps: [
        const VerificationStep(
          id: 'uploaded',
          name: 'Đã tải hồ sơ',
          subLabel: 'Tài liệu đã được hệ thống ghi nhận',
          status: VerificationStepStatus.done,
          iconPath: AppImages.icCheckBold,
        ),
        const VerificationStep(
          id: 'checking',
          name: 'Đang kiểm tra tính xác thực',
          subLabel: 'Đang xử lý nội bộ',
          status: VerificationStepStatus.active,
          iconPath: AppImages.icRefreshCw,
        ),
        const VerificationStep(
          id: 'activate',
          name: 'Kích hoạt tài khoản',
          subLabel: 'Chờ hoàn tất kiểm tra',
          status: VerificationStepStatus.pending,
          iconPath: AppImages.icLock,
        ),
      ],
    ));

    // TODO: start polling or subscribe to WebSocket for status changes.
    // When status changes, dispatch WaitingApprovalStatusUpdated.
  }

  void _onStatusUpdated(
    WaitingApprovalStatusUpdated event,
    Emitter<WaitingApprovalState> emit,
  ) {
    emit(state.copyWith(pageStatus: event.newStatus));
  }

  Future<void> _onSupportTapped(
    WaitingApprovalSupportTapped event,
    Emitter<WaitingApprovalState> emit,
  ) async {
    final uri = Uri.parse('tel:19006868');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _onGoHomeTapped(
    WaitingApprovalGoHomeTapped event,
    Emitter<WaitingApprovalState> emit,
  ) {
    // Navigation is handled by BlocListener in the UI layer.
  }
}
