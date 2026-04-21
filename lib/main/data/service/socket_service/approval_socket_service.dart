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
      print("⚠️Approval Socket đang init hoặc đã init");
      return;
    }

    _isConnecting = true;

    final user = await SharePreferenceUtil.getUser();

    print("🚀Approval Init socket với userId: ${user?.id}");

    socket = IO.io(
      'http://160.30.173.186:3001', // ⚠️ nhớ đúng port
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({'userId': user?.id})
          // force userid de debug
          // .setQuery({'userId': "160245943409884827"})
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

    print('🔧Approval Setup listeners');

    socket!.onConnect((_) {
      print('✅Approval Connected: ${socket!.id}');
    });
    socket!.onError((error) {
      print('❌Approval Error: $error');
    });
    socket!.onDisconnect((reason) {
      print('❌Approval Disconnected: $reason');
    });

    socket!.on('driver.application_approved', (data) {
      print('📨Approval driver.application_approved');
      _approvalController.add(data);
    });

    socket!.onAny((event, data) {
      print('📡Approval $event');
    });
  }

  void dispose() {
    print("🧹Approval Dispose socket");
    socket?.disconnect();
    socket = null;
    _isInitialized = false;
  }
}
