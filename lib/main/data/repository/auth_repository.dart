import 'package:demo_app/main/data/api/api_end_point.dart';
import 'package:demo_app/main/data/api/api_util.dart';
import 'package:demo_app/main/data/model/user/user.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';

class AuthRepository {
  AuthRepository._();
  static final AuthRepository _instance = AuthRepository._();
  factory AuthRepository() => _instance;

  static const String _userPath = 'https://jsonplaceholder.typicode.com/users';

  /// GET danh sach user va parse thanh List<User>
  Future<List<User>> getUsers() async {
    return ApiUtil.getInstance()!.getParsed<List<User>>(
      url: _userPath,
      fromJson: (json) {
        final dynamic usersData = json['data'] ?? json['result'] ?? json;
        if (usersData is List) {
          return usersData
              .whereType<Map<String, dynamic>>()
              .map(User.fromJson)
              .toList();
        }
        return <User>[];
      },
    );
  }

  /// GET chi tiet user theo id
  Future<User> getUserDetail(String id) async {
    return ApiUtil.getInstance()!.getParsed<User>(
      url: '$_userPath/$id',
      fromJson: (json) {
        final dynamic userData = json['data'] ?? json['result'] ?? json;
        if (userData is Map<String, dynamic>) {
          return User.fromJson(userData);
        }
        return User.fromJson(const {});
      },
    );
  }

  /// POST tao moi user
  Future<User> createUser(User user) async {
    return ApiUtil.getInstance()!.postParsed<User>(
      url: _userPath,
      body: user.toJson(),
      fromJson: (json) {
        final dynamic userData = json['data'] ?? json['result'] ?? json;
        if (userData is Map<String, dynamic>) {
          return User.fromJson(userData);
        }
        return User.fromJson(const {});
      },
    );
  }

  /// PUT cap nhat user
  Future<User> updateUser({
    required String id,
    required User user,
  }) async {
    return ApiUtil.getInstance()!.putParsed<User>(
      url: '$_userPath/$id',
      body: user.toJson(),
      fromJson: (json) {
        final dynamic userData = json['data'] ?? json['result'] ?? json;
        if (userData is Map<String, dynamic>) {
          return User.fromJson(userData);
        }
        return User.fromJson(const {});
      },
    );
  }

  /// DELETE user, tra ve true neu status success
  Future<bool> deleteUser(String id) async {
    final response = await ApiUtil.getInstance()!.delete(
      url: '$_userPath/$id',
    );
    return response.isSuccess || response.isStatusSuccess;
  }

  /// Gửi OTP với phone và type, trả về true nếu API trả về success
  Future<(bool, String)> sendOtp({
    required String phone,
    required int type,
  }) async {
    final response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_AUTHENTICATE_OTP,
      body: {
        "phone": phone,
        "type": type,
      },
    );
    print("response.data ${response.data}");
    print("response.message ${response.message}");

    bool isSuccess = false;
    String message = response.message ?? '';

    // Nếu API trả về field success riêng, ta có thể check response.data
    if (response.data is Map<String, dynamic>) {
      final Map<String, dynamic> data = response.data;
      print("data $data");
      if (data.containsKey('success')) {
        print("data['success'] ${data['success']}");
        isSuccess = data['success'] == true;
      }
      if (data.containsKey('message') && data['message'] != null) {
        message = data['message'].toString();
      }
    }
    return (isSuccess, message);
  }

  Future<(bool, String)> register({
    required String phone,
    required String password,
    required String fullName,
    required String otp,
  }) async {
    final deviceId = await SharePreferenceUtil.getDeviceId();
    final deviceToken = await SharePreferenceUtil.getDeviceToken();
    final deviceType = await SharePreferenceUtil.getDeviceName();
    final response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_REGISTER,
      body: {
        "phone": phone,
        "password": password,
        "password_confirmation": password,
        "full_name": fullName,
        "otp": otp,
        "device_id": deviceId,
        "device_token": deviceToken,
        "device_type": deviceType,
      },
    );
    print("response.data ${response.data}");
    print("response.message ${response.message}");

    bool isSuccess = false;
    String message = response.message ?? '';

    // Nếu API trả về field success riêng, ta có thể check response.data
    if (response.data is Map<String, dynamic>) {
      final Map<String, dynamic> data = response.data;
      print("data $data");
      if (data.containsKey('success')) {
        print("data['success'] ${data['success']}");
        isSuccess = data['success'] == true;
      }
      if (data.containsKey('data') && data['data'] != null) {
        final Map<String, dynamic> userData = data['data'];
        final User user = User.fromJson(userData);
        print("user ${user.toJson()}");
        SharePreferenceUtil.saveUser(user);
      }
      if (data.containsKey('message') && data['message'] != null) {
        message = data['message'].toString();
      }
    }
    return (isSuccess, message);
  }

  Future<(bool, String)> login({
    required String phone,
    required String password,
  }) async {
    final deviceId = await SharePreferenceUtil.getDeviceId();
    final deviceToken = await SharePreferenceUtil.getDeviceToken();
    final deviceType = await SharePreferenceUtil.getDeviceName();
    final response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_LOGIN,
      body: {
        "phone": phone,
        "password": password,
        "device_id": deviceId,
        "device_token": deviceToken,
        "device_type": deviceType,
      },
    );
    print("response.data ${response.data}");
    print("response.message ${response.message}");

    bool isSuccess = false;
    String message = response.message ?? '';

    // Nếu API trả về field success riêng, ta có thể check response.data
    if (response.data is Map<String, dynamic>) {
      final Map<String, dynamic> data = response.data;
      print("data $data");
      if (data.containsKey('success')) {
        print("data['success'] ${data['success']}");
        isSuccess = data['success'] == true;
      }
      if (data.containsKey('data') && data['data'] != null) {
        final Map<String, dynamic> userData = data['data'];
        final User user = User.fromJson(userData);
        print("user ${user.toJson()}");
        SharePreferenceUtil.saveUser(user);
      }
      if (data.containsKey('message') && data['message'] != null) {
        message = data['message'].toString();
      }
    }
    return (isSuccess, message);
  }
}
