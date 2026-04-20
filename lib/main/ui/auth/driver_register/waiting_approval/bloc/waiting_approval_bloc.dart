import 'dart:async';

import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/data/service/socket_service/approval_socket_service.dart';
import 'package:demo_app/main/data/service/socket_service/socket_service.dart';
import 'package:url_launcher/url_launcher.dart';

part 'waiting_approval_event.dart';
part 'waiting_approval_state.dart';

class WaitingApprovalBloc
    extends Bloc<WaitingApprovalEvent, WaitingApprovalState> {
  // final SocketService _socketService = SocketService();
  late StreamSubscription _sub;

  WaitingApprovalBloc() : super(const WaitingApprovalState()) {
    on<WaitingApprovalInitialised>(_onInitialised);
    on<WaitingApprovalStatusUpdated>(_onStatusUpdated);
    on<WaitingApprovalSupportTapped>(_onSupportTapped);
    on<WaitingApprovalGoHomeTapped>(_onGoHomeTapped);

    add(const WaitingApprovalInitialised());
    // print("bloc log bat dau khoi tao socket");
    // // connectToRealtime();
    // // Khởi tạo Socket khi Bloc được tạo
    // _socketService.init();

    // // Lắng nghe từ SocketService
    // _socketService.onApplicationApproved.listen((data) {
    //   add(WaitingApprovalStatusUpdated(WaitingApprovalPageStatus.approved));
    //   print("data: $data");
    // });
    print("setup approval socket service o waiting approval bloc");
    _sub = ApprovalSocketService().onApplicationApproved.listen((data) {
      add(WaitingApprovalStatusUpdated(WaitingApprovalPageStatus.approved));
    });
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

  @override
  Future<void> close() {
    _sub.cancel(); // ⚠️ bắt buộc
    return super.close();
  }
}
