// socket_service.dart
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';
import 'package:flutter/foundation.dart';

class SocketService {
  // Singleton
  static final SocketService instance = SocketService._internal();
  SocketService._internal();

  IO.Socket? socket;
  bool _isConnected = false;
  String? _currentRideId;

  // Stream để lắng nghe các event
  final _trackingStateController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _trackingUpdatedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _errorController = StreamController<String>.broadcast();

  Stream<Map<String, dynamic>> get onTrackingState =>
      _trackingStateController.stream;
  Stream<Map<String, dynamic>> get onTrackingUpdated =>
      _trackingUpdatedController.stream;
  Stream<String> get onError => _errorController.stream;

  // Getter kiểm tra trạng thái
  bool get isConnected => _isConnected && socket?.connected == true;

  /// Khởi tạo và kết nối Socket
  void connect({
    required String realtimeUrl,
    required String rideId,
    String? bearerToken,
  }) {
    if (isConnected && _currentRideId == rideId) {
      print("SocketService: Đã kết nối rideId này rồi");
      return;
    }

    disconnect(); // Ngắt kết nối cũ trước

    print("SocketService: Đang kết nối đến $realtimeUrl | RideID: $rideId");

    _currentRideId = rideId;

    socket = IO.io(realtimeUrl, <String, dynamic>{
      'transports': ['websocket', 'polling'],
      'autoConnect': true,
      'reconnection': true,
      'reconnectionAttempts': 10,
      'reconnectionDelay': 2000,
      'timeout': 10000,
      'auth': {
        'rideId': rideId,
        if (bearerToken != null) 'token': bearerToken,
      },
    });

    _setupListeners();
    socket!.connect();
  }

  void _setupListeners() {
    if (socket == null) return;

    socket!.on('connect', (_) {
      _isConnected = true;
      print('✅ Socket connected | ID: ${socket!.id}');

      // Join room sau khi kết nối thành công
      if (_currentRideId != null) {
        socket!.emit('ride:join', {'rideId': _currentRideId});
        print('📤 Đã gửi ride:join cho rideId: $_currentRideId');
      }
    });

    socket!.on('disconnect', (reason) {
      _isConnected = false;
      print('❌ Socket disconnected. Lý do: $reason');
    });

    socket!.on('connect_error', (error) {
      print('❌ Socket connect_error: $error');
      _errorController.add('Kết nối socket thất bại: $error');
    });

    socket!.on('error', (error) {
      print('❌ Socket error: $error');
      _errorController.add('Socket error: $error');
    });

    // ==================== EVENTS TỪ SERVER ====================
    socket!.on('ride:tracking.state', (data) {
      print('📨 Nhận được ride:tracking.state');
      if (data is Map<String, dynamic>) {
        _trackingStateController.add(data);
      }
    });

    socket!.on('ride:tracking.updated', (data) {
      print('📨 Nhận được ride:tracking.updated');
      if (data is Map<String, dynamic>) {
        _trackingUpdatedController.add(data);
      }
    });

    socket!.on('ride:tracking.error', (data) {
      print('⚠️ Nhận được ride:tracking.error');
      _errorController.add(data?['message']?.toString() ?? 'Lỗi tracking');
    });
  }

  /// Ngắt kết nối
  void disconnect() {
    if (socket != null) {
      print("SocketService: Đang ngắt kết nối...");
      socket!.disconnect();
      socket!.dispose();
      socket = null;
    }
    _isConnected = false;
    _currentRideId = null;
  }

  /// Gửi event thủ công (nếu cần)
  void emit(String event, [dynamic data]) {
    if (socket?.connected == true) {
      socket!.emit(event, data);
      print("📤 Emit event: $event | Data: $data");
    } else {
      print("⚠️ Không thể emit vì socket chưa kết nối");
    }
  }

  /// Giải phóng tài nguyên
  void dispose() {
    disconnect();
    _trackingStateController.close();
    _trackingUpdatedController.close();
    _errorController.close();
  }
}
