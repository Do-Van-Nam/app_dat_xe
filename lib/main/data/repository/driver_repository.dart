import 'package:demo_app/main/data/api/api_end_point.dart';
import 'package:demo_app/main/data/api/api_util.dart';
import 'package:demo_app/main/data/model/ride/ride.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';
import '../../base/base_response.dart';

class DriverRepository {
  DriverRepository._();
  static final DriverRepository _instance = DriverRepository._();
  factory DriverRepository() => _instance;

  Future<Map<String, String>> _authHeader() async {
    // final token = await SharePreferenceUtil.getLoginToken();
    final token = "157|YXmshfVpzaxPKalr1qeYXws81WmCISKfls4W3Q4P314f44f2";
    return {"Authorization": "Bearer $token"};
  }

  // ============================================================
  // Cập nhật trạng thái online/offline và vị trí
  // PUT /api/v1/driver/status
  // ============================================================
  Future<(bool, String)> updateStatus({
    required bool isOnline,
    required double lat,
    required double lng,
  }) async {
    final BaseResponse response = await ApiUtil.getInstance()!.put(
      url: ApiEndPoint.DOMAIN_DRIVER_STATUS,
      headers: await _authHeader(),
      body: {
        "is_online": isOnline,
        "current_lat": lat,
        "current_lng": lng,
      },
    );

    return (response.isSuccess, response.message ?? "");
  }

  // ============================================================
  // Chấp nhận chuyến xe
  // POST /api/v1/driver/ride/{rideId}/accept
  // ============================================================
  Future<(bool, String, Ride)> acceptRide({
    required dynamic rideId,
    required double lat,
    required double lng,
  }) async {
    final BaseResponse response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_DRIVER_RIDE_ACCEPT(rideId),
      headers: await _authHeader(),
      body: {
        "current_lat": lat,
        "current_lng": lng,
      },
    );
    Ride ride = Ride();
    if (response.data is Map<String, dynamic>) {
      final Map<String, dynamic> data = response.data;
      if (data.containsKey('data') && data['data'] != null) {
        final userData = data['data']['ride'] ?? data['data'];
        ride = Ride.fromJson(userData as Map<String, dynamic>);
      }
    }
    return (response.isSuccess, response.message ?? "", ride);
  }

  // ============================================================
  // Từ chối chuyến xe
  // POST /api/v1/driver/ride/{rideId}/reject
  // ============================================================
  Future<(bool, String)> rejectRide(dynamic rideId) async {
    final BaseResponse response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_DRIVER_RIDE_REJECT(rideId),
      headers: await _authHeader(),
    );

    return (response.isSuccess, response.message ?? "");
  }

  // ============================================================
  // Tài xế hủy chuyến xe
  // POST /api/v1/driver/ride/{rideId}/cancel
  // ============================================================
  Future<(bool, String)> driverCancelRide({
    required dynamic rideId,
    required int reasonId,
    required double lat,
    required double lng,
  }) async {
    final BaseResponse response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_DRIVER_RIDE_CANCEL(rideId),
      headers: await _authHeader(),
      body: {
        "reason_id": reasonId,
        "current_lat": lat,
        "current_lng": lng,
      },
    );

    return (response.isSuccess, response.message ?? "");
  }

  // ============================================================
  // Bắt đầu chuyến xe
  // POST /api/v1/driver/ride/{rideId}/start
  // ============================================================
  Future<(bool, String)> startRide(
      dynamic rideId, double lat, double lng) async {
    final BaseResponse response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_DRIVER_RIDE_START(rideId),
      headers: await _authHeader(),
      body: {"lat": lat, "lng": lng},
    );
    return (response.isSuccess, response.message ?? "");
  }

  // ============================================================
  // Hoàn thành chuyến xe
  // POST /api/v1/driver/ride/{rideId}/complete
  // ============================================================
  Future<(bool, String)> completeRide(
      dynamic rideId, double lat, double lng) async {
    final BaseResponse response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_DRIVER_RIDE_COMPLETE(rideId),
      headers: await _authHeader(),
      body: {"lat": lat, "lng": lng},
    );
    return (response.isSuccess, response.message ?? "");
  }

  // ============================================================
  // Đã đến điểm đón
  // POST /api/v1/driver/ride/{rideId}/arrived
  // ============================================================
  Future<(bool, String)> arrivedAtPickup(
      dynamic rideId, double lat, double lng) async {
    final BaseResponse response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_DRIVER_RIDE_ARRIVED(rideId),
      headers: await _authHeader(),
      body: {"lat": lat, "lng": lng},
    );
    return (response.isSuccess, response.message ?? "");
  }

  // ============================================================
  // Đã lấy hàng / đón khách
  // POST /api/v1/driver/ride/{rideId}/pickup
  // ============================================================
  Future<(bool, String)> confirmPickup(
      dynamic rideId, double lat, double lng) async {
    final BaseResponse response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_DRIVER_RIDE_PICKUP(rideId),
      headers: await _authHeader(),
      body: {"lat": lat, "lng": lng},
    );
    return (response.isSuccess, response.message ?? "");
  }
}
