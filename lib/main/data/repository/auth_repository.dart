import 'dart:io';
import 'package:demo_app/main/data/api/api_end_point.dart';
import 'package:demo_app/main/data/api/api_util.dart';
import 'package:demo_app/main/data/model/user/user.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  AuthRepository._();
  static final AuthRepository _instance = AuthRepository._();
  factory AuthRepository() => _instance;

  /// Gửi OTP với phone và type, trả về true nếu API trả về success
  Future<(bool, String)> requestOtp({
    required String phone,
    required int type, // 1: register, 3: forget password , 2: login
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
      if (data.containsKey('data')) {
        print("data['data'] ${data['data']}");
        print("data['data']['otp_code'] ${data['data']['otp_code']}");
        SharePreferenceUtil.saveOtpCode(data['data']['otp_code']);
      }
      if (data.containsKey('message') && data['message'] != null) {
        message = data['message'].toString();
      }
    }
    return (isSuccess, message);
  }

  Future<(bool, String)> register(
      {required String phone,
      required String password,
      required String fullName,
      required String otp,
      int role = 2}) async {
    final deviceId = await SharePreferenceUtil.getDeviceId();
    final deviceToken = await SharePreferenceUtil.getDeviceToken();
    final deviceType = await SharePreferenceUtil.getDeviceType();
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
        "role": role,
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
        final Map<String, dynamic> userData = data['data']['user'];
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
    final deviceType = await SharePreferenceUtil.getDeviceType();
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
        final Map<String, dynamic> responseData = data['data'];
        if (responseData.containsKey('user') && responseData['user'] != null) {
          final User user = User.fromJson(responseData['user']);
          print("luu user vao share preference ${user.toJson()}");
          SharePreferenceUtil.saveUser(user);
        }
        if (responseData.containsKey('token') &&
            responseData['token'] != null) {
          final String token = responseData['token'];
          print("luu login token vao share preference ${token}");
          SharePreferenceUtil.saveLoginToken(token);
        }
      }
      if (data.containsKey('message') && data['message'] != null) {
        message = data['message'].toString();
      }
    }
    return (isSuccess, message);
  }

  // Quên mật khẩu
  Future<(bool, String)> resetPassword({
    required String phone,
    required String otp,
    required String password,
  }) async {
    final deviceId = await SharePreferenceUtil.getDeviceId();
    final deviceToken = await SharePreferenceUtil.getDeviceToken();
    final deviceType = await SharePreferenceUtil.getDeviceType();
    final response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_FORGOT_PASSWORD,
      body: {
        "phone": phone,
        "otp": otp,
        "password": password,
        "password_confirmation": password,
        "device_id": deviceId,
        "device_token": deviceToken,
        "device_type": deviceType,
      },
    );
    bool isSuccess = false;
    String message = response.message ?? '';

    if (response.data is Map<String, dynamic>) {
      final Map<String, dynamic> data = response.data;
      if (data.containsKey('success')) {
        isSuccess = data['success'] == true;
      }
      if (data.containsKey('message') && data['message'] != null) {
        message = data['message'].toString();
      }
    }
    return (isSuccess, message);
  }

  // Lấy thông tin user hiện tại
  Future<(bool, User?)> getMe() async {
    final response = await ApiUtil.getInstance()!.get(
      url: ApiEndPoint.DOMAIN_ME,
    );
    if (response.isSuccess) {
      if (response.data is Map<String, dynamic>) {
        final Map<String, dynamic> data = response.data;
        if (data.containsKey('data') && data['data'] != null) {
          final Map<String, dynamic> responseData = data['data'];
          if (responseData.containsKey('user') &&
              responseData['user'] != null) {
            final user = User.fromJson(responseData['user']);
            SharePreferenceUtil.saveUser(user);
            return (data['success'] == true, user);
          } else {
            final user = User.fromJson(responseData);
            SharePreferenceUtil.saveUser(user);
            return (data['success'] == true, user);
          }
        }
      }
    }
    return (false, null);
  }

  // Đăng xuất
  Future<(bool, String)> logout({bool logoutAll = true}) async {
    final token = await SharePreferenceUtil.getLoginToken();
    await SharePreferenceUtil.saveLoginToken("");
    await SharePreferenceUtil.saveUser(null);
    final response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_LOGOUT,
      body: {
        "logout_all": logoutAll,
      },
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    bool isSuccess = false;
    String message = response.message ?? '';

    if (response.data is Map<String, dynamic>) {
      final Map<String, dynamic> data = response.data;
      if (data.containsKey('success')) {
        isSuccess = data['success'] == true;
      }
      if (data.containsKey('message') && data['message'] != null) {
        message = data['message'].toString();
      }
    }

    return (isSuccess, message);
  }

  // Đăng ký/đăng nhập Google
  Future<(bool, String)> googleLogin({required String idToken}) async {
    final deviceId = await SharePreferenceUtil.getDeviceId();
    final deviceToken = await SharePreferenceUtil.getDeviceToken();
    final deviceType = await SharePreferenceUtil.getDeviceType();

    final response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_GOOGLE_LOGIN,
      body: {
        "device_id": deviceId,
        "device_token": deviceToken,
        "device_type": deviceType,
        "id_token": idToken,
      },
    );
    bool isSuccess = false;
    String message = response.message ?? '';

    if (response.data is Map<String, dynamic>) {
      final Map<String, dynamic> data = response.data;
      if (data.containsKey('success')) {
        isSuccess = data['success'] == true;
      }
      if (data.containsKey('message') && data['message'] != null) {
        message = data['message'].toString();
      }
      if (data.containsKey('data') && data['data'] != null) {
        final Map<String, dynamic> responseData = data['data'];
        if (responseData.containsKey('user') && responseData['user'] != null) {
          final user = User.fromJson(responseData['user']);
          SharePreferenceUtil.saveUser(user);
        }
      }
    }
    return (isSuccess, message);
  }

  // Đăng ký/đăng nhập Apple
  Future<(bool, String)> appleLogin({
    required String idToken,
    required String userFullName,
  }) async {
    final deviceId = await SharePreferenceUtil.getDeviceId();
    final deviceToken = await SharePreferenceUtil.getDeviceToken();
    final deviceType = await SharePreferenceUtil.getDeviceType();

    final response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_APPLE_LOGIN,
      body: {
        "id_token": idToken,
        "user": userFullName,
        "device_id": deviceId,
        "device_token": deviceToken,
        "device_type": deviceType,
      },
    );
    bool isSuccess = false;
    String message = response.message ?? '';

    if (response.data is Map<String, dynamic>) {
      final Map<String, dynamic> data = response.data;
      if (data.containsKey('success')) {
        isSuccess = data['success'] == true;
      }
      if (data.containsKey('message') && data['message'] != null) {
        message = data['message'].toString();
      }
      if (data.containsKey('data') && data['data'] != null) {
        final Map<String, dynamic> responseData = data['data'];
        if (responseData.containsKey('user') && responseData['user'] != null) {
          final user = User.fromJson(responseData['user']);
          SharePreferenceUtil.saveUser(user);
        }
      }
    }
    return (isSuccess, message);
  }

  // ============================================================
  // Gửi OTP đăng ký tài xế
  // POST /api/v1/driver/register/send-otp
  // ============================================================
  Future<(bool, String, User?)> sendDriverRegisterOtp(
      Map<String, dynamic> body) async {
    final response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_DRIVER_REGISTER_SEND_OTP,
      body: body,
    );

    bool isSuccess = false;
    String message = response.message ?? '';
    User? user;

    if (response.data is Map<String, dynamic>) {
      final Map<String, dynamic> data = response.data;
      isSuccess = data['success'] == true;
      message = data['message']?.toString() ?? message;

      if (data.containsKey('data') && data['data'] != null) {
        final userData = data['data']['user'] ?? data['data'];
        user = User.fromJson(userData as Map<String, dynamic>);
      }
    }
    return (isSuccess, message, user);
  }

  // ============================================================
  // Submit đăng ký tài xế (Multipart)
  // POST /api/v1/driver/register/submit
  // ============================================================
  Future<(bool, String, User?)> submitDriverRegister(
      Map<String, dynamic> body) async {
    // Để upload file với Dio, ta cần gói body vào FormData
    // Body giả định chứa các trường text và các trường file (đã được convert qua MultipartFile)
    final formData = FormData.fromMap(body);

    final response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_DRIVER_REGISTER_SUBMIT,
      body: formData,
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    );

    bool isSuccess = false;
    String message = response.message ?? '';
    User? user;

    if (response.data is Map<String, dynamic>) {
      final Map<String, dynamic> data = response.data;
      isSuccess = data['success'] == true;
      message = data['message']?.toString() ?? message;

      if (data.containsKey('data') && data['data'] != null) {
        final userData = data['data']['user'] ?? data['data'];
        user = User.fromJson(userData as Map<String, dynamic>);
      }
    }
    return (isSuccess, message, user);
  }
}
