import 'package:demo_app/main/data/api/api_end_point.dart';
import 'package:demo_app/main/data/api/api_util.dart';
import 'package:demo_app/main/data/model/ride/call.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:demo_app/main/data/model/ride/ride.dart';
import 'package:demo_app/main/data/model/ride/vehicle.dart';
import 'package:demo_app/main/data/model/ride/price.dart';
import '../../base/base_response.dart';

class RideRepository {
  RideRepository._();
  static final RideRepository _instance = RideRepository._();
  factory RideRepository() => _instance;

  Future<Map<String, String>> _authHeader() async {
    final token = await SharePreferenceUtil.getLoginToken();
    return {"Authorization": "Bearer $token"};
  }

  // ============================================================
  // Tạo chuyến xe tạm thời
  // POST /api/v1/ride/draft
  // ============================================================
  Future<(bool, Ride?)> createDraftRide(Map<String, dynamic> body) async {
    final BaseResponse response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_RIDE_DRAFT,
      body: body,
      headers: await _authHeader(),
    );

    if (response.isSuccess && response.data != null) {
      try {
        final data = response.data['data'] ?? response.data;
        return (true, Ride.fromJson(data as Map<String, dynamic>));
      } catch (e) {
        print('❌ createDraftRide parse error: $e');
      }
    }
    return (false, null);
  }

  // ============================================================
  // Lấy danh sách loại xe
  // GET /api/v1/ride/{rideId}/vehicles
  // ============================================================
  Future<(bool, List<Vehicle>)> getVehicles(dynamic rideId) async {
    try {
      final BaseResponse response = await ApiUtil.getInstance()!.get(
        url: ApiEndPoint.DOMAIN_RIDE_VEHICLES(rideId),
        headers: await _authHeader(),
      );

      if (response.isSuccess && response.data != null) {
        final rawData = response.data['data'] ?? response.data;

        // Kiểm tra rawData có phải List không
        if (rawData is List) {
          final vehicles = rawData
              .map((e) => Vehicle.fromJson(e as Map<String, dynamic>))
              .toList();

          return (true, vehicles);
        } else if (rawData is Map<String, dynamic>) {
          // Một số API trả về object có key "data" là List
          final list = rawData['data'];
          if (list is List) {
            final vehicles = list
                .map((e) => Vehicle.fromJson(e as Map<String, dynamic>))
                .toList();
            return (true, vehicles);
          }
        }
      }

      // Trường hợp thất bại hoặc không có dữ liệu
      return (false, <Vehicle>[]);
    } catch (e, stack) {
      print('❌ getVehicles error: $e');
      print('Stack trace: $stack');
      return (false, <Vehicle>[]);
    }
  }

  // ============================================================
  // Xem giá ước tính
  // GET /api/v1/ride/{rideId}/price
  // ============================================================
  Future<(bool, Price?)> getPrice(dynamic rideId) async {
    final BaseResponse response = await ApiUtil.getInstance()!.get(
      url: ApiEndPoint.DOMAIN_RIDE_PRICE(rideId),
      headers: await _authHeader(),
    );

    if (response.isSuccess && response.data != null) {
      try {
        final data = response.data['data'] ?? response.data;
        return (true, Price.fromJson(data as Map<String, dynamic>));
      } catch (e) {
        print('❌ getPrice parse error: $e');
      }
    }
    return (false, null);
  }

  // ============================================================
  // Áp dụng voucher
  // POST /api/v1/ride/{rideId}/voucher
  // ============================================================
  Future<(bool, Price?)> applyVoucher(
      dynamic rideId, String voucherCode) async {
    final BaseResponse response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_RIDE_VOUCHER(rideId),
      body: {"voucher_code": voucherCode},
      headers: await _authHeader(),
    );

    if (response.isSuccess && response.data != null) {
      try {
        final data = response.data['data'] ?? response.data;
        return (true, Price.fromJson(data as Map<String, dynamic>));
      } catch (e) {
        print('❌ applyVoucher parse error: $e');
      }
    }
    return (false, null);
  }

  // ============================================================
  // Xóa voucher
  // DELETE /api/v1/ride/{rideId}/voucher
  // ============================================================
  Future<(bool, Price?)> removeVoucher(dynamic rideId) async {
    final BaseResponse response = await ApiUtil.getInstance()!.delete(
      url: ApiEndPoint.DOMAIN_RIDE_VOUCHER(rideId),
      headers: await _authHeader(),
    );

    if (response.isSuccess && response.data != null) {
      try {
        final data = response.data['data'] ?? response.data;
        return (true, Price.fromJson(data as Map<String, dynamic>));
      } catch (e) {
        print('❌ removeVoucher parse error: $e');
      }
    }
    return (false, null);
  }

  // ============================================================
  // Xác nhận đặt chuyến
  // POST /api/v1/ride/{rideId}/confirm
  // ============================================================
  Future<(bool, Ride?)> confirmRide(dynamic rideId, int expectedPrice) async {
    final BaseResponse response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_RIDE_CONFIRM(rideId),
      body: {"expected_price": expectedPrice},
      headers: await _authHeader(),
    );

    if (response.isSuccess && response.data != null) {
      try {
        final data = response.data['data'] ?? response.data;
        return (true, Ride.fromJson(data as Map<String, dynamic>));
      } catch (e) {
        print('❌ confirmRide parse error: $e');
      }
    }
    return (false, null);
  }

  // ============================================================
  // Hủy chuyến xe
  // POST /api/v1/ride/{id}/cancel
  // ============================================================
  Future<(bool, Ride?)> cancelRide(dynamic rideId, String reason) async {
    final BaseResponse response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_RIDE_CANCEL(rideId),
      body: {"reason": reason},
      headers: await _authHeader(),
    );

    if (response.isSuccess) {
      try {
        // final data = response.data['data'] ?? response.data;
        // return (true, Ride.fromJson(data as Map<String, dynamic>));
        return (true, null);
      } catch (e) {
        print('❌ cancelRide parse error: $e');
      }
    }
    return (false, null);
  }

// yeu cau huy chuyen sau khi da co tai xe nhan
  Future<(bool, Ride?)> cancelRideRequest(dynamic rideId, String reason) async {
    final BaseResponse response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_RIDE_CANCEL_REQUEST(rideId),
      body: {"reason": reason},
      headers: await _authHeader(),
    );

    if (response.isSuccess && response.data != null) {
      try {
        final data = response.data['data'] ?? response.data;
        await SharePreferenceUtil.saveCurrentRide(null);
        return (true, Ride.fromJson(data as Map<String, dynamic>));
      } catch (e) {
        print('❌ cancelRide parse error: $e');
      }
    }
    return (false, null);
  }

  // / yeu cau huy chuyen sau khi da co tai xe nhan
  Future<(bool, Call?)> getCallInfo(dynamic rideId) async {
    final BaseResponse response = await ApiUtil.getInstance()!.get(
      url: ApiEndPoint.DOMAIN_RIDE_CALL_INFO(rideId),
      headers: await _authHeader(),
    );

    if (response.isSuccess && response.data != null) {
      try {
        final data = response.data['data'] ?? response.data;
        await SharePreferenceUtil.saveCurrentRide(null);
        return (true, Call.fromJson(data as Map<String, dynamic>));
      } catch (e) {
        print('❌ getCallInfo parse error: $e');
      }
    }
    return (false, null);
  }
}
