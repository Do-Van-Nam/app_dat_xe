// socket_service.dart
import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? socket;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) {
      print("SocketService: Đã khởi tạo rồi, bỏ qua...");
      return;
    }
    final user = await SharePreferenceUtil.getUser();
    print("SocketService: Bắt đầu khởi tạo Socket... voi userId ${user?.id}");

    // socket = IO.io('http://160.30.173.186:8002', {
    //   'transports': ['websocket'],
    //   'autoConnect': false,
    //   'reconnection': true, // Bật tự động reconnect
    //   'reconnectionAttempts': 5,
    //   'reconnectionDelay': 2000,
    // }, );
    socket = IO.io(
        'http://160.30.173.186:8002',
        IO.OptionBuilder()
            .setTransports(['websocket']) // Bắt buộc dùng websocket để ổn định
            // gui them thong tin userId len server,
            // neu server emit voi userId nay, hoac emit cho tat ca thi se nhan duoc event
            .setQuery({
          'userId':
              user?.id ?? "160079173451580383" // ID của tài xế đang đăng nhập
        }).build());

    _setupListeners();
    socket!.connect();

    _isInitialized = true;
  }

  void _setupListeners() {
    print('🔧 Đang setup Socket listeners...');

    socket!.on('connect', (_) {
      print('✅ Socket connected thành công!');
      print('   Socket ID: ${socket!.id}');
    });

    socket!
        .on('disconnect', (reason) => print('❌ Socket disconnected: $reason'));
    socket!.on('connect_error', (error) => print('❌ Connect error: $error'));

    // ==================== CÁC LISTENER CHÍNH ====================

    // Cách 1: Lắng nghe trực tiếp event từ Redis
    socket!.on('driver.application_approved', (data) {
      print('📨 Nhận được event: driver.application_approved');
      print('   Data: $data');
      _approvalController.add(data);
    });

    // Cách 2: Lắng nghe theo channel Redis (rất hay gặp)
    socket!.on('ride.communication.events', (data) {
      print('📨 Nhận được từ channel ride.communication.events');
      print('   Raw data: $data');

      if (data is Map && data['event'] == 'driver.application_approved') {
        print('   → Phát hiện event driver.application_approved');
        _approvalController.add(data);
      }
    });

    // Cách 3: Catch all - Để debug (rất quan trọng lúc này)
    socket!.onAny((event, data) {
      print('📡 [onAny] Event: "$event"');
      print('       Data: $data');
    });
  }

  final _approvalController = StreamController<dynamic>.broadcast();
  Stream<dynamic> get onApplicationApproved => _approvalController.stream;

  void dispose() {
    print("SocketService: Đang đóng kết nối...");
    _approvalController.close();
    socket?.disconnect();
    socket = null;
    _isInitialized = false;
  }
}
//
