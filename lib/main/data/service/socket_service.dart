// socket_service.dart
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? socket;
  bool _isInitialized = false;

  void init() {
    if (_isInitialized) {
      print("SocketService: Đã khởi tạo rồi, bỏ qua...");
      return;
    }

    print("SocketService: Bắt đầu khởi tạo Socket...");

    socket = IO.io('http://160.30.173.186:8002', {
      'transports': ['websocket'],
      'autoConnect': false,
      'reconnection': true, // Bật tự động reconnect
      'reconnectionAttempts': 5,
      'reconnectionDelay': 2000,
    });

    _setupListeners();
    socket!.connect();

    _isInitialized = true;
  }

  void _setupListeners() {
    print('🔧 Đang setup Socket listeners...');

    socket!.on('connect', (_) {
      print('✅ Socket connected thành công!');
      print('   ID: ${socket!.id}');
    });

    socket!
        .on('disconnect', (reason) => print('❌ Socket disconnected: $reason'));
    socket!.on('connect_error', (error) => print('❌ Connect error: $error'));
    socket!.on('error', (error) => print('❌ Socket error: $error'));

    // === CATCH ALL - Quan trọng để debug ===
    socket!.onAny((event, data) {
      print('📡 Nhận được event: "$event"');
      print('   Data: $data');
    });

    // Event cụ thể của bạn
    socket!.on('driver.application_approved', (data) {
      print('📨 Nhận được event: driver.application_approved');
      print('   Data: $data');
      _approvalController.add(data);
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
