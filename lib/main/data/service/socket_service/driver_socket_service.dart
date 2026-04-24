import 'dart:async';

import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum SocketConnectionStatus {
  idle,
  initializing,
  connecting,
  connected,
  disconnected,
  reconnecting,
  error,
}

class DriverSocketService {
  static final DriverSocketService _instance = DriverSocketService._internal();
  factory DriverSocketService() => _instance;
  DriverSocketService._internal();

  IO.Socket? _socket;

  bool _isInitialized = false;
  bool _isInitializing = false;

  String? _currentUserId;
  String? _pendingRideId;
  bool _listenersAttached = false;

  final _approvalController = StreamController<dynamic>.broadcast();
  final _rideEventController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _statusController =
      StreamController<SocketConnectionStatus>.broadcast();

  Stream<dynamic> get onApplicationApproved => _approvalController.stream;
  Stream<Map<String, dynamic>> get onRideEvent => _rideEventController.stream;
  Stream<SocketConnectionStatus> get onStatusChanged =>
      _statusController.stream;

  SocketConnectionStatus _status = SocketConnectionStatus.idle;
  SocketConnectionStatus get status => _status;

  IO.Socket? get socket => _socket;
  bool get isConnected => _socket?.connected == true;
  bool get isInitialized => _isInitialized;

  void _setStatus(SocketConnectionStatus newStatus) {
    _status = newStatus;
    if (!_statusController.isClosed) {
      _statusController.add(newStatus);
    }
    print('DriverSocketService 📶 Socket status: $newStatus');
  }

  Future<void> init({String? rideId}) async {
    if (rideId != null) {
      _pendingRideId = rideId;
    }

    if (_isInitializing) {
      print('DriverSocketService ⚠️ Socket đang khởi tạo, bỏ qua init trùng');
      return;
    }

    if (_isInitialized && isConnected) {
      print('DriverSocketService ✅ Socket đã kết nối rồi');
      if (_pendingRideId != null) {
        joinRide(_pendingRideId!);
      }
      return;
    }

    _isInitializing = true;
    _setStatus(SocketConnectionStatus.initializing);

    try {
      final user = await SharePreferenceUtil.getUser();
      final userId = (user?.id ?? "0").toString();
      _currentUserId = userId;

      print('DriverSocketService 🚀 Khởi tạo socket với userId=$userId');

      if (_socket == null) {
        _socket = _createSocket(userId);
      }

      if (!_listenersAttached) {
        _attachCoreListeners();
        _attachBusinessListeners();
        _listenersAttached = true;
      }

      if (!isConnected) {
        _connect();
      }

      _isInitialized = true;
    } catch (e) {
      print('DriverSocketService ❌ Lỗi init socket: $e');
      _setStatus(SocketConnectionStatus.error);
      rethrow;
    } finally {
      _isInitializing = false;
    }
  }

  IO.Socket _createSocket(String userId) {
    return IO.io(
      'http://160.30.173.186:8002',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(2000)
          // force tai xe duoi 091
          // .setQuery({'userId': "160245943409884827"})
          .setQuery({'userId': userId})
          .build(),
    );
  }

  void _connect() {
    if (_socket == null) return;
    if (_socket!.connected) {
      print('DriverSocketService ✅ Socket đã connected, không connect lại');
      return;
    }

    print('DriverSocketService 🔌 Đang connect socket...');
    _setStatus(SocketConnectionStatus.connecting);
    _socket!.connect();
  }

  void _attachCoreListeners() {
    final s = _socket;
    if (s == null) return;

    print('DriverSocketService 🔧 Gắn core listeners');

    s.onConnect((_) {
      print('DriverSocketService ✅ Socket connected: ${s.id}');
      _setStatus(SocketConnectionStatus.connected);
      _joinRideAfterConnect();
    });

    s.onDisconnect((reason) {
      print('DriverSocketService ❌ Socket disconnected: $reason');
      _setStatus(SocketConnectionStatus.disconnected);
    });

    s.onConnectError((error) {
      print('DriverSocketService ❌ Socket connect error: $error');
      _setStatus(SocketConnectionStatus.error);
    });

    s.onError((error) {
      print('DriverSocketService ❌ Socket error: $error');
      _setStatus(SocketConnectionStatus.error);
    });

    s.onReconnectAttempt((attempt) {
      print('DriverSocketService 🔄 Reconnect attempt: $attempt');
      _setStatus(SocketConnectionStatus.reconnecting);
    });

    s.onReconnect((attempt) {
      print('DriverSocketService ✅ Reconnected after $attempt attempt(s)');
      _setStatus(SocketConnectionStatus.connected);
      _joinRideAfterConnect();
    });

    s.onAny((event, data) {
      print('DriverSocketService 📡 [onAny] "$event" | $data');
    });
  }

  void _attachBusinessListeners() {
    final s = _socket;
    if (s == null) return;

    print('DriverSocketService 🎯 Gắn business listeners');

    s.on('driver.application_approved', (data) {
      print('DriverSocketService 📨 driver.application_approved: $data');
      if (!_approvalController.isClosed) {
        _approvalController.add(data);
      }
    });

    s.on('ride.accepted', (data) {
      print('DriverSocketService 📨 ride.accepted: $data');
      _emitRideEvent('ride.accepted', data);
    });

    s.on('ride.arrived', (data) {
      print('DriverSocketService 📨 ride.arrived: $data');
      _emitRideEvent('ride.arrived', data);
    });

    s.on('ride.picked_up', (data) {
      print('DriverSocketService 📨 ride.picked_up: $data');
      _emitRideEvent('ride.picked_up', data);
    });
    s.on('ride.started', (data) {
      print('DriverSocketService 📨 ride.started: $data');
      _emitRideEvent('ride.started', data);
    });

    s.on('ride.completed', (data) {
      print('DriverSocketService 📨 ride.completed: $data');
      _emitRideEvent('ride.completed', data);
    });

    s.on('ride.new_offer', (data) {
      print('DriverSocketService 📨 ride.new_offer: $data');
      _emitRideEvent('ride.new_offer', data);
    });
// {user_id: 160245943409884827, event: ride.new_offer, ride_id: 160803027243049444, pickup_address: 5 ngo 58 tran vy, destination_address: 5 ngo 58 tran vy, distance_km: 5, total_price: 35000, vehicle_type: BIKE, occurred_at: 2026-04-20T09:21:09+00:00}
    s.on('ride.rejected', (data) {
      print('DriverSocketService 📨 ride.rejected: $data');
      _emitRideEvent('ride.rejected', data);
    });

    s.on('ride.cancelled', (data) {
      print('DriverSocketService 📨 ride.cancelled: $data');
      _emitRideEvent('ride.cancelled', data);
    });
    s.on('ride.cancellation_requested', (data) {
      print('DriverSocketService 📨 ride.cancellation_requested: $data');
      _emitRideEvent('ride.cancellation_requested', data);
    });
    s.on('ride:tracking.updated', (data) {
      print('DriverSocketService 📨 ride:tracking.updated: $data');
      _emitRideEvent('ride:tracking.updated', data);
    });

    // tin nhan
    s.on('communication.chat.message.sent', (data) {
      print('DriverSocketService 📨 communication.chat.message.sent: $data');
      _emitRideEvent('communication.chat.message.sent', data);
    });

    s.on('ride:join:response', (response) {
      print('DriverSocketService 📍 ride:join:response: $response');
    });

    s.on('room:joined', (response) {
      print('DriverSocketService 📍 room:joined: $response');
    });
  }

  void _emitRideEvent(String event, dynamic data) {
    if (_rideEventController.isClosed) {
      print("user socket service log: ride event controller is closed");
      return;
    }
    _rideEventController.add({
      'event': event,
      'data': data,
    });
  }

  void _joinRideAfterConnect() {
    final rideId = _pendingRideId;
    if (rideId == null) return;
    joinRide(rideId);
  }

  void joinRide(String rideId) {
    _pendingRideId = rideId;

    final s = _socket;
    if (s == null) {
      print(
          'DriverSocketService ⚠️ Chưa có socket, lưu pending rideId=$rideId');
      return;
    }

    if (!s.connected) {
      print(
          'DriverSocketService ⚠️ Socket chưa connected, lưu pending rideId=$rideId');
      return;
    }

    print('DriverSocketService 🚗 Join ride room: $rideId');
    print('DriverSocketService    Socket connected? ${s.connected}');
    print('DriverSocketService    Socket id: ${s.id}');

    try {
      s.emit('ride:join', {'rideId': rideId});
      print('DriverSocketService  ✓ Emit ride:join thành công');
    } catch (e) {
      print('DriverSocketService  ✗ Emit ride:join lỗi: $e');
    }
  }

  Future<void> reconnect() async {
    if (_socket == null) {
      print('DriverSocketService ⚠️ Socket chưa được tạo, gọi init lại');
      await init(rideId: _pendingRideId);
      return;
    }

    if (_socket!.connected) {
      print('DriverSocketService ✅ Socket đang connected, không reconnect');
      return;
    }

    _connect();
  }

  void disconnect() {
    print('DriverSocketService 🔌 SocketService disconnect');
    _socket?.disconnect();
    _setStatus(SocketConnectionStatus.disconnected);
  }

  void dispose() {
    print('DriverSocketService 🧹 SocketService dispose');

    _socket?.dispose();
    _socket = null;

    _isInitialized = false;
    _isInitializing = false;
    _listenersAttached = false;
    _currentUserId = null;
    _pendingRideId = null;

    if (!_approvalController.isClosed) {
      _approvalController.close();
    }
    if (!_rideEventController.isClosed) {
      _rideEventController.close();
    }
    if (!_statusController.isClosed) {
      _statusController.close();
    }

    _setStatus(SocketConnectionStatus.idle);
  }
}

//init
// await SocketService().init();

// join chuyen 
// SocketService().joinRide(rideId);


// dung o file bloc 
  // late StreamSubscription _sub;
// trong init bloc 
// _sub = DriverSocketService().onApplicationApproved.listen((data) {
//       add(WaitingApprovalStatusUpdated(WaitingApprovalPageStatus.approved));
//     });

  // @override
  // Future<void> close() {
  //   _sub.cancel(); // ⚠️ bắt buộc
  //   return super.close();
  // }