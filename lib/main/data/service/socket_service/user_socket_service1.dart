import 'dart:async';

import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:demo_app/main/utils/service/local_notification_service.dart';
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

class UserSocketService {
  static final UserSocketService _instance = UserSocketService._internal();
  factory UserSocketService() => _instance;
  UserSocketService._internal();

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
    print('UserSocketService 📶 Socket status: $newStatus');
  }

  Future<void> init({String? rideId}) async {
    if (rideId != null) {
      _pendingRideId = rideId;
    }

    if (_isInitializing) {
      print('UserSocketService ⚠️ Socket đang khởi tạo, bỏ qua init trùng');
      return;
    }

    if (_isInitialized && isConnected) {
      print('UserSocketService ✅ Socket đã kết nối rồi');
      if (_pendingRideId != null) {
        joinRide(_pendingRideId!);
      }
      return;
    }

    _isInitializing = true;
    _setStatus(SocketConnectionStatus.initializing);

    try {
      final user = await SharePreferenceUtil.getUser();
      final userId = (user?.id ?? "160079173451580383").toString();
      _currentUserId = userId;

      print('UserSocketService 🚀 Khởi tạo socket với userId=$userId');

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
      print('UserSocketService ❌ Lỗi init socket: $e');
      _setStatus(SocketConnectionStatus.error);
      rethrow;
    } finally {
      _isInitializing = false;
    }
  }

  IO.Socket _createSocket(String userId) {
    return IO.io(
      'http://160.30.173.186:8002',

      // 'http://160.30.173.186:3001',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(2000)
          .setQuery({'userId': userId})
          // .setQuery({'userId': "160245943409884827"})
          .build(),
    );
  }

  void _connect() {
    if (_socket == null) return;
    if (_socket!.connected) {
      print('UserSocketService ✅ Socket đã connected, không connect lại');
      return;
    }

    print('UserSocketService 🔌 Đang connect socket...');
    _setStatus(SocketConnectionStatus.connecting);
    _socket!.connect();
  }

  void _attachCoreListeners() {
    final s = _socket;
    if (s == null) return;

    print('UserSocketService 🔧 Gắn core listeners');

    s.onConnect((_) {
      print('UserSocketService ✅ Socket connected: ${s.id}');
      _setStatus(SocketConnectionStatus.connected);
      _joinRideAfterConnect();
    });

    s.onDisconnect((reason) {
      print('UserSocketService ❌ Socket disconnected: $reason');
      _setStatus(SocketConnectionStatus.disconnected);
    });

    s.onConnectError((error) {
      print('UserSocketService ❌ Socket connect error: $error');
      _setStatus(SocketConnectionStatus.error);
    });

    s.onError((error) {
      print('UserSocketService ❌ Socket error: $error');
      _setStatus(SocketConnectionStatus.error);
    });

    s.onReconnectAttempt((attempt) {
      print('UserSocketService 🔄 Reconnect attempt: $attempt');
      _setStatus(SocketConnectionStatus.reconnecting);
    });

    s.onReconnect((attempt) {
      print('UserSocketService ✅ Reconnected after $attempt attempt(s)');
      _setStatus(SocketConnectionStatus.connected);
      _joinRideAfterConnect();
    });

    s.onAny((event, data) {
      print('UserSocketService 📡 [onAny] "$event" | $data');
    });
  }

  void _attachBusinessListeners() {
    final s = _socket;
    if (s == null) return;

    print('UserSocketService 🎯 Gắn business listeners');

    s.on('driver.application_approved', (data) {
      print('UserSocketService 📨 driver.application_approved: $data');
      if (!_approvalController.isClosed) {
        _approvalController.add(data);
      }
    });

    s.on('ride.accepted', (data) async {
      print('UserSocketService 📨 ride.accepted: $data');
      await LocalNotificationService.instance.showNotification(
        title: "Đã tìm thấy tài xế cho chuyến đi của bạn",
        body: "Tài xế sẽ đến đón bạn sớm",
      );
      _emitRideEvent('ride.accepted', data);
    });

    s.on('ride.arrived', (data) async {
      await LocalNotificationService.instance.showNotification(
        title: "Tài xế đã đến điểm đón",
        body: "Tài xế đã đến điểm đón",
      );
      print('UserSocketService 📨 ride.arrived: $data');
      _emitRideEvent('ride.arrived', data);
    });

    s.on('ride.picked_up', (data) async {
      await LocalNotificationService.instance.showNotification(
        title: "Tài xế đã đón bạn",
        body: "Tài xế đã đón bạn",
      );
      print('UserSocketService 📨 ride.picked_up: $data');
      _emitRideEvent('ride.picked_up', data);
    });
    s.on('ride.started', (data) async {
      await LocalNotificationService.instance.showNotification(
        title: "Chuyến đi đã bắt đầu",
        body: "Chuyến đi đã bắt đầu",
      );
      print('UserSocketService 📨 ride.started: $data');
      _emitRideEvent('ride.started', data);
    });

    s.on('ride.completed', (data) async {
      await LocalNotificationService.instance.showNotification(
        title: "Chuyến đi đã hoàn thành",
        body: "Chuyến đi đã hoàn thành",
      );
      await SharePreferenceUtil.saveCurrentRide(null);
      print('UserSocketService 📨 ride.completed: $data');
      _emitRideEvent('ride.completed', data);
    });
    s.on('ride.rejected', (data) async {
      await SharePreferenceUtil.saveCurrentRide(null);
      await LocalNotificationService.instance.showNotification(
        title: "Chuyến đi đã bị từ chối",
        body: "Chuyến đi đã bị từ chối",
      );
      print('UserSocketService 📨 ride.rejected: $data');
      _emitRideEvent('ride.rejected', data);
    });

    s.on('ride.cancelled', (data) async {
      await SharePreferenceUtil.saveCurrentRide(null);
      await LocalNotificationService.instance.showNotification(
        title: "Chuyến đi đã bị hủy",
        body: "Chuyến đi đã bị hủy",
      );
      print('UserSocketService 📨 ride.cancelled: $data');
      _emitRideEvent('ride.cancelled', data);
    });

    s.on('ride:tracking.updated', (data) {
      print('UserSocketService 📨 ride:tracking.updated: $data');
      _emitRideEvent('ride:tracking.updated', data);
    });

    s.on('ride:join:response', (response) {
      print('UserSocketService 📍 ride:join:response: $response');
    });

    s.on('room:joined', (response) {
      print('UserSocketService 📍 room:joined: $response');
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
      print('UserSocketService ⚠️ Chưa có socket, lưu pending rideId=$rideId');
      return;
    }

    if (!s.connected) {
      print(
          'UserSocketService ⚠️ Socket chưa connected, lưu pending rideId=$rideId');
      return;
    }

    print('UserSocketService 🚗 Join ride room: $rideId');
    print('UserSocketService    Socket connected? ${s.connected}');
    print('UserSocketService    Socket id: ${s.id}');

    try {
      s.emit('ride:join', {'rideId': rideId});
      print('UserSocketService  ✓ Emit ride:join thành công');
    } catch (e) {
      print('UserSocketService  ✗ Emit ride:join lỗi: $e');
    }
  }

  Future<void> reconnect() async {
    if (_socket == null) {
      print('UserSocketService ⚠️ Socket chưa được tạo, gọi init lại');
      await init(rideId: _pendingRideId);
      return;
    }

    if (_socket!.connected) {
      print('UserSocketService ✅ Socket đang connected, không reconnect');
      return;
    }

    _connect();
  }

  void disconnect() {
    print('UserSocketService 🔌 SocketService disconnect');
    _socket?.disconnect();
    _setStatus(SocketConnectionStatus.disconnected);
  }

  void dispose() {
    print('UserSocketService 🧹 SocketService dispose');

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
// _sub = UserSocketService().onApplicationApproved.listen((data) {
//       add(WaitingApprovalStatusUpdated(WaitingApprovalPageStatus.approved));
//     });

  // @override
  // Future<void> close() {
  //   _sub.cancel(); // ⚠️ bắt buộc
  //   return super.close();
  // }