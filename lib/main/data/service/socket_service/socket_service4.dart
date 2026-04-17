import 'package:socket_io_client/socket_io_client.dart' as IO;

void connectToRealtime() {
  // 1. Khởi tạo kết nối tới IP công cộng của Server và cổng 8002
  print("bat dau ket noi ");
  IO.Socket socket = IO.io(
      'http://160.30.173.186:8002',
      IO.OptionBuilder()
          .setTransports(['websocket']) // Bắt buộc dùng websocket để ổn định
          .setQuery({
        'userId': '160079173451580383' // ID của tài xế đang đăng nhập
      }).build());
  // 2. Khi kết nối thành công
  socket.onConnect((_) {
    print('Kết nối Realtime thành công!');
  });
  print("ket thuc khoi tao ket noi");
  socket.on('driver.application_approved', (data) {
    // 1. Phân tích dữ liệu nhận được
    print('Nhận dữ liệu phê duyệt: $data');

    // 2. Cập nhật trạng thái App hoặc hiển thị thông báo UI
    // Ví dụ: Hiển thị một Thông báo (Snackbar) hoặc Dialog thành công
    // _showApprovalDialog(context, data['application_id']);
  });
  // 3. Lắng nghe sự kiện hồ sơ được duyệt
  // Đây là sự kiện mà Laravel bắn ra sau khi tôi đã khôi phục code server.js
  socket.on('driver.application_approved', (data) {
    print('NHẬN ĐƯỢC THÔNG BÁO DUYỆT HỒ SƠ: $data');

    // logic hiển thị thông báo trên màn hình App (ví dụ dùng Flushbar hoặc ShowDialog)
    // Dữ liệu 'data' sẽ bao gồm application_id và thời gian occurred_at
  });
  // 4. Lắng nghe lỗi nếu có
  socket.onConnectError((data) => print('Lỗi kết nối: $data'));
}
