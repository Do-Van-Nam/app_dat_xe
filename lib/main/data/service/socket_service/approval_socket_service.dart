import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';

class ApprovalSocketService {
  static final ApprovalSocketService _instance =
      ApprovalSocketService._internal();
  factory ApprovalSocketService() => _instance;
  ApprovalSocketService._internal();

  IO.Socket? socket;
  bool _isInitialized = false;
  bool _isConnecting = false;

  final _approvalController = StreamController<dynamic>.broadcast();
  Stream<dynamic> get onApplicationApproved => _approvalController.stream;

  Future<void> init() async {
    if (_isInitialized || _isConnecting) {
      print("⚠️ Socket đang init hoặc đã init");
      return;
    }

    _isConnecting = true;

    final user = await SharePreferenceUtil.getUser();

    print("🚀 Init socket với userId: ${user?.id}");

    socket = IO.io(
      'http://160.30.173.186:3001', // ⚠️ nhớ đúng port
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({'userId': user?.id})
          .disableAutoConnect() // 👈 QUAN TRỌNG
          .build(),
    );

    _setupListeners();

    socket!.connect();

    _isInitialized = true;
    _isConnecting = false;
  }

  void _setupListeners() {
    if (socket == null) return;

    print('🔧 Setup listeners');

    socket!.onConnect((_) {
      print('✅ Connected: ${socket!.id}');
    });

    socket!.onDisconnect((reason) {
      print('❌ Disconnected: $reason');
    });

    socket!.on('driver.application_approved', (data) {
      print('📨 driver.application_approved');
      _approvalController.add(data);
    });

    socket!.onAny((event, data) {
      print('📡 $event');
    });
  }

  void dispose() {
    print("🧹 Dispose socket");
    socket?.disconnect();
    socket = null;
    _isInitialized = false;
  }
}
