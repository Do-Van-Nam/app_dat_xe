import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';

//  file nay goi socket thanh cong 17:00 17/4

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? socket;
  bool _isInitialized = false;

  final _approvalController = StreamController<dynamic>.broadcast();
  final _rideEventController = StreamController<dynamic>.broadcast();

  Stream<dynamic> get onApplicationApproved => _approvalController.stream;
  Stream<dynamic> get onRideEvent => _rideEventController.stream;

  // ============================================================

  String? _pendingRideId;

  Future<void> init({String? rideId}) async {
    if (_isInitialized && socket?.connected == true) {
      print("SocketService: Đã kết nối rồi");
      if (rideId != null) {
        _joinRide(rideId);
      }
      return;
    }

    final user = await SharePreferenceUtil.getUser();
    print("SocketService: Khởi tạo với userId=${user?.id}");

    _pendingRideId = rideId; // Lưu rideId để dùng sau khi connect

    socket = IO.io(
      'http://160.30.173.186:8002',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(2000)
          .setQuery({'userId': user?.id ?? "160079173451580383"})
          .build(),
    );

    _setupListeners();
    socket!.connect();
    _isInitialized = true;
  }

  void _joinRideAfterConnect() {
    if (_pendingRideId != null) {
      _joinRide(_pendingRideId!);
    }
  }

  void _joinRide(String rideId) {
    print('🚗 Vào phòng chuyến xe: $rideId');
    print('   Socket connected? ${socket?.connected}');
    print('   Socket id: ${socket?.id}');

    try {
      socket!.emit('ride:join', {'rideId': rideId});
      print('   ✓ Emit ride:join thành công');
    } catch (e) {
      print('   ✗ Emit error: $e');
    }

    // Lắng nghe response từ server
    socket!.once('ride:join:response', (response) {
      print('📍 [RESPONSE] ride:join:response: $response');
    });

    // Nếu server emit event khác để confirm
    socket!.once('room:joined', (response) {
      print('📍 [RESPONSE] room:joined: $response');
    });

    // Catch all để xem server emit event gì
    socket!.onAny((event, data) {
      if (event.contains('join') || event.contains('room')) {
        print('📡 [onAny] JOIN/ROOM event: "$event" | $data');
      }
    });
  }

  void _setupListeners() {
    print('🔧 Setup Socket listeners...');

    socket!.on('connect', (_) {
      print('✅ Socket connected: ${socket!.id}');
      _joinRideAfterConnect();
    });

    socket!.on('disconnect', (reason) {
      print('❌ Disconnected: $reason');
      _isInitialized = false;
    });

    socket!.on('connect_error', (error) {
      print('❌ Connect error: $error');
    });

    // === Các event chuyến xe ===
    socket!.on('ride.accepted', (data) {
      print('📨 ride.accepted: $data');
      _rideEventController.add({'event': 'ride.accepted', 'data': data});
    });

    socket!.on('ride.rejected', (data) {
      print('📨 ride.rejected: $data');
      _rideEventController.add({'event': 'ride.rejected', 'data': data});
    });

    socket!.on('ride.cancelled', (data) {
      print('📨 ride.cancelled: $data');
      _rideEventController.add({'event': 'ride.cancelled', 'data': data});
    });

    socket!.on('ride:tracking.updated', (data) {
      print('📨 ride:tracking.updated: $data');
      _rideEventController
          .add({'event': 'ride:tracking.updated', 'data': data});
    });

    // === Event cũ (nếu still dùng) ===
    socket!.on('driver.application_approved', (data) {
      print('📨 driver.application_approved: $data');
      _approvalController.add(data);
    });

    // === Debug: catch all ===
    socket!.onAny((event, data) {
      print('📡 [onAny] "$event" | $data');
    });
  }

  void disconnect() {
    print("SocketService: Disconnecting...");
    socket?.disconnect();
    socket = null;
    _isInitialized = false;
  }

  void dispose() {
    print("SocketService: Disposing...");
    disconnect();
    _approvalController.close();
    _rideEventController.close();
  }
}
