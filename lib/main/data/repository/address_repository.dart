// address_repository.dart

import 'package:demo_app/main/data/api/api_end_point.dart';
import 'package:demo_app/main/data/api/api_util.dart';
import 'package:demo_app/main/data/model/address.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';

import '../../base/base_response.dart';

class AddressRepository {
  AddressRepository._();
  static final AddressRepository _instance = AddressRepository._();
  factory AddressRepository() => _instance;

  // ============================================================
  // HELPER
  // ============================================================

  Future<Map<String, String>> _authHeader() async {
    final token = await SharePreferenceUtil.getLoginToken();
    return {"Authorization": "Bearer $token"};
  }

  Address? _parseAddress(dynamic data) {
    if (data is! Map<String, dynamic>) return null;
    try {
      return Address.fromJson(data['data'] as Map<String, dynamic>);
    } catch (e, st) {
      print('❌ _parseAddress error: $e\n$st');
      return null;
    }
  }

  List<Address> _parseAddressList(dynamic data) {
    if (data is! Map<String, dynamic>) return [];
    try {
      final list = data['data'] as List<dynamic>;
      return list
          .map((e) => Address.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      print('❌ _parseAddressList error: $e\n$st');
      return [];
    }
  }

  // ============================================================
  // UC-06: Lấy danh sách địa chỉ đã lưu
  // GET /api/v1/user/addresses
  // ============================================================

  /// Trả về (true, List<Address>) nếu thành công, (false, []) nếu lỗi
  Future<(bool, List<Address>)> getAddresses() async {
    final BaseResponse response = await ApiUtil.getInstance()!.get(
      url: ApiEndPoint.DOMAIN_USER_ADDRESSES,
      headers: await _authHeader(),
    );

    if (response.isSuccess) {
      final list = _parseAddressList(response.data);
      return (true, list);
    }

    return (false, <Address>[]);
  }

  // ============================================================
  // UC-06: Tạo mới địa chỉ
  // POST /api/v1/user/addresses
  // ============================================================

  /// Trả về (true, Address) nếu tạo thành công, (false, null) nếu lỗi
  Future<(bool, Address?)> createAddress(Map<String, dynamic> fields) async {
    final BaseResponse response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_USER_ADDRESSES,
      body: fields,
      headers: await _authHeader(),
    );

    if (response.isSuccess) {
      final address = _parseAddress(response.data);
      if (address != null) return (true, address);
    }

    return (false, null);
  }

  // ============================================================
  // UC-06: Xem chi tiết địa chỉ
  // GET /api/v1/user/addresses/{id}
  // ============================================================

  /// Trả về (true, Address) nếu thành công, (false, null) nếu lỗi
  Future<(bool, Address?)> getAddressDetail(int id) async {
    final BaseResponse response = await ApiUtil.getInstance()!.get(
      url: ApiEndPoint.DOMAIN_USER_ADDRESS_DETAIL(id),
      headers: await _authHeader(),
    );

    if (response.isSuccess) {
      final address = _parseAddress(response.data);
      if (address != null) return (true, address);
    }

    return (false, null);
  }

  // ============================================================
  // UC-06: Cập nhật địa chỉ
  // PUT /api/v1/user/addresses/{id}
  // ============================================================

  /// Trả về (true, Address) nếu cập nhật thành công, (false, null) nếu lỗi
  Future<(bool, Address?)> updateAddress(
    int id,
    Map<String, dynamic> fields,
  ) async {
    final BaseResponse response = await ApiUtil.getInstance()!.put(
      url: ApiEndPoint.DOMAIN_USER_ADDRESS_DETAIL(id),
      body: fields,
      headers: await _authHeader(),
    );

    if (response.isSuccess) {
      final address = _parseAddress(response.data);
      if (address != null) return (true, address);
    }

    return (false, null);
  }

  // ============================================================
  // UC-06: Xóa địa chỉ
  // DELETE /api/v1/user/addresses/{id}
  // ============================================================

  /// Trả về true nếu xóa thành công, false nếu lỗi
  Future<bool> deleteAddress(int id) async {
    final BaseResponse response = await ApiUtil.getInstance()!.delete(
      url: ApiEndPoint.DOMAIN_USER_ADDRESS_DETAIL(id),
      headers: await _authHeader(),
    );

    return response.isSuccess;
  }

  // ============================================================
  // UC-06: Đặt địa chỉ mặc định
  // POST /api/v1/user/addresses/{id}/default
  // ============================================================

  /// Trả về (true, Address) nếu đặt mặc định thành công, (false, null) nếu lỗi
  Future<(bool, Address?)> setDefaultAddress(int id) async {
    final BaseResponse response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_USER_ADDRESS_DEFAULT(id),
      headers: await _authHeader(),
    );

    if (response.isSuccess) {
      final address = _parseAddress(response.data);
      if (address != null) return (true, address);
    }

    return (false, null);
  }
}
