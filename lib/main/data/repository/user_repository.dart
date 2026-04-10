// user_repository.dart

import 'package:demo_app/main/data/api/api_end_point.dart';
import 'package:demo_app/main/data/api/api_util.dart';
import 'package:demo_app/main/data/model/user/user.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';

import '../../base/base_response.dart';

class UserRepository {
  UserRepository._();
  static final UserRepository _instance = UserRepository._();
  factory UserRepository() => _instance;

  // ============================================================
  // HELPER
  // ============================================================

  User? _parseAndSaveUser(dynamic data) {
    if (data is! Map<String, dynamic>) return null;
    try {
      print("data trong ham parse: $data");
      final user = User.fromJson(data['data']);
      print("user sau ham parse: ${user.toJson()}");
      SharePreferenceUtil.saveUser(user);
      return user;
    } catch (e, stackTrace) {
      print('❌ _parseAndSaveUser error: $e');
      print(stackTrace);
      return null;
    }
  }

  // ============================================================
  // UC-04: Lấy thông tin hồ sơ
  // ============================================================

  Future<(bool, User?)> getUserProfile() async {
    final token = await SharePreferenceUtil.getLoginToken();
    print("token lay khi goi api profile: $token");
    final BaseResponse response = await ApiUtil.getInstance()!.get(
      url: ApiEndPoint.DOMAIN_USER_PROFILE,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.isSuccess) {
      final user = _parseAndSaveUser(response.data);
      print("user sau ham repository khi goi api profile: ${user?.toJson()}");
      if (user != null) return (true, user);
    }

    return (false, null);
  }

  // ============================================================
  // UC-05: Cập nhật thông tin hồ sơ
  // ============================================================

  /// Trả về:
  /// - (true, user)  → cập nhật thành công
  /// - (true, null)  → cần xác thực OTP (kiểm tra response.isOtpRequired ở UI)
  /// - (false, null) → có lỗi
  Future<(bool, User?)> updateUserProfile(Map<String, dynamic> fields) async {
    final token = await SharePreferenceUtil.getLoginToken();
    final BaseResponse response = await ApiUtil.getInstance()!.put(
      url: ApiEndPoint.DOMAIN_USER_PROFILE,
      body: fields,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    // HTTP 202 - Yêu cầu OTP, xử lý ở tầng UI/BLoC
    // if (response.isOtpRequired) return (true, null);
    print("response update profile: ${response.toJson()}");
    if (response.isSuccess) {
      final user = _parseAndSaveUser(response.data);
      if (response.message != null &&
          response.message!.contains("xác thực OTP")) {
        print("contain xac thuc otp");
        return (true, null);
      } else if (user != null) {
        return (true, user);
      }
    }

    return (false, null);
  }

  // ============================================================
  // UC-05: Xác thực OTP
  // ============================================================

  Future<(bool, User?)> verifyProfileOtp({
    required String otp,
    Map<String, dynamic>? sensitiveData,
  }) async {
    final token = await SharePreferenceUtil.getLoginToken();
    final BaseResponse response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_VERIFY_PROFILE_OTP,
      body: {
        'otp': otp,
        'sensitive_data': sensitiveData ?? {},
      },
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.isSuccess) {
      final user = _parseAndSaveUser(response.data);
      if (user != null) return (true, user);
    }

    return (false, null);
  }

  // ============================================================
  // UC-05: Đổi mật khẩu
  // ============================================================

  Future<(bool, String?)> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    final token = await SharePreferenceUtil.getLoginToken();
    final BaseResponse response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_CHANGE_PASSWORD,
      body: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      },
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    print("response errors: ${response.errors}");
    final message = getErrorMessage(response);
    return (response.isSuccess, message);
  }
}

String getErrorMessage(dynamic response) {
  if (response == null) {
    return "Đã xảy ra lỗi không xác định";
  }

  String mainMessage = response.message?.toString() ?? "Mật khẩu không hợp lệ.";

  // Xử lý phần errors
  if (response.errors != null) {
    try {
      final errors = response.errors as Map;

      // Lấy lỗi current_password trước
      if (errors.containsKey('current_password')) {
        final currentError = errors['current_password'];
        if (currentError is List && currentError.isNotEmpty) {
          mainMessage += "\n${currentError[0]}";
          return mainMessage; // Ưu tiên current_password
        } else if (currentError != null) {
          mainMessage += "\n$currentError";
          return mainMessage;
        }
      }

      // Nếu không có current_password thì lấy new_password
      if (errors.containsKey('new_password')) {
        final newError = errors['new_password'];
        if (newError is List && newError.isNotEmpty) {
          mainMessage += "\n${newError[0]}";
        } else if (newError != null) {
          mainMessage += "\n$newError";
        }
      }
    } catch (e) {
      // Trường hợp ép kiểu lỗi
      print("Error parsing errors: $e");
    }
  }

  return mainMessage;
}
