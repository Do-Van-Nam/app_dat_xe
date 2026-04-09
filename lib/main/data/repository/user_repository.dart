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
      final user = User.fromJson(data);
      SharePreferenceUtil.saveUser(user);
      return user;
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // UC-04: Lấy thông tin hồ sơ
  // ============================================================

  Future<(bool, User?)> getUserProfile() async {
    final token = SharePreferenceUtil.getLoginToken();
    final BaseResponse response = await ApiUtil.getInstance()!.get(
      url: ApiEndPoint.DOMAIN_USER_PROFILE,
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
  // UC-05: Cập nhật thông tin hồ sơ
  // ============================================================

  /// Trả về:
  /// - (true, user)  → cập nhật thành công
  /// - (true, null)  → cần xác thực OTP (kiểm tra response.isOtpRequired ở UI)
  /// - (false, null) → có lỗi
  Future<(bool, User?)> updateUserProfile(Map<String, dynamic> fields) async {
    final BaseResponse response = await ApiUtil.getInstance()!.put(
      url: ApiEndPoint.DOMAIN_USER_PROFILE,
      body: fields,
    );

    // HTTP 202 - Yêu cầu OTP, xử lý ở tầng UI/BLoC
    // if (response.isOtpRequired) return (true, null);

    if (response.isSuccess) {
      final user = _parseAndSaveUser(response.data);
      if (user != null) return (true, user);
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
    final BaseResponse response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_VERIFY_PROFILE_OTP,
      body: {
        'otp': otp,
        'sensitive_data': sensitiveData ?? {},
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
    final BaseResponse response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_CHANGE_PASSWORD,
      body: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      },
    );

    return (response.isSuccess, response.message);
  }
}
