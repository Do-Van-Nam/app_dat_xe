import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';
import 'dart:convert';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? socket;
  bool _isInitialized = false;

  // Stream cho từng loại event
  final _approvalController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _userUpdateController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get onApplicationApproved =>
      _approvalController.stream;
  Stream<Map<String, dynamic>> get onUserUpdated =>
      _userUpdateController.stream;

  // ============================================================

  void init({required String userId}) {
    if (_isInitialized && socket?.connected == true) {
      print("SocketService: Đã kết nối rồi");
      return;
    }

    print("SocketService: Khởi tạo với userId=$userId");

    socket = IO.io(
      'http://160.30.173.186:8002',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(2000)
          .setQuery({'userId': userId}) // Server dùng để tự join room
          .build(),
    );

    _setupListeners();
    socket!.connect();
    _isInitialized = true;
  }

  void _setupListeners() {
    socket!.onConnect((_) {
      print('✅ Socket connected: ${socket!.id}');
    });

    socket!.on('disconnect', (reason) {
      print('❌ Disconnected: $reason');
    });

    socket!.on('connect_error', (error) {
      print('❌ Connect error: $error');
    });

    // Phê duyệt hồ sơ tài xế
    socket!.on('driver.application_approved', (data) {
      print('📨 driver.application_approved: $data');
      final map = _toMap(data);
      if (map != null) _approvalController.add(map);
    });

    // Cập nhật chung của user
    socket!.on('user:communication.updated', (data) {
      print('📨 user:communication.updated: $data');
      final map = _toMap(data);
      if (map != null) _userUpdateController.add(map);
    });

    // Debug: bắt tất cả event (xoá khi production)
    socket!.onAny((event, data) {
      print('📡 [onAny] "$event" | $data');
    });
  }

  // ============================================================

  Map<String, dynamic>? _toMap(dynamic data) {
    try {
      if (data is Map<String, dynamic>) return data;
      if (data is String) return jsonDecode(data) as Map<String, dynamic>;
      if (data is Map) return Map<String, dynamic>.from(data);
    } catch (e) {
      print('❌ _toMap error: $e');
    }
    return null;
  }

  void dispose() {
    _approvalController.close();
    _userUpdateController.close();
    socket?.disconnect();
    socket = null;
    _isInitialized = false;
  }
}
