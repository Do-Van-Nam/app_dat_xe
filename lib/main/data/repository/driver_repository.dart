import 'package:demo_app/main/data/api/api_end_point.dart';
import 'package:demo_app/main/data/api/api_util.dart';
import 'package:demo_app/main/data/model/ride/ride.dart';
import 'package:demo_app/main/data/model/ride/ride_income_summary.dart';
import 'package:demo_app/main/data/model/finance/wallet.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';
import '../../base/base_response.dart';

class DriverRepository {
  DriverRepository._();
  static final DriverRepository _instance = DriverRepository._();
  factory DriverRepository() => _instance;

  Future<Map<String, String>> _authHeader() async {
    final token = await SharePreferenceUtil.getLoginToken();
    // final token = "157|YXmshfVpzaxPKalr1qeYXws81WmCISKfls4W3Q4P314f44f2";
    return {"Authorization": "Bearer $token"};
  }

  Ride? _parseRide(dynamic data) {
    if (data is! Map<String, dynamic>) return null;
    try {
      return Ride.fromJson(data);
    } catch (e) {
      print('❌ parseRide error: $e');
      return null;
    }
  }

  List<Ride> _parseRideList(dynamic data) {
    final rawData =
        data is Map<String, dynamic> ? (data['data'] ?? data) : data;
    final candidates = [
      rawData,
      rawData is Map<String, dynamic> ? rawData['rides'] : null,
      rawData is Map<String, dynamic> ? rawData['items'] : null,
      rawData is Map<String, dynamic> ? rawData['results'] : null,
    ];

    for (final candidate in candidates) {
      if (candidate is List) {
        return candidate
            .whereType<Map<String, dynamic>>()
            .map(Ride.fromJson)
            .toList();
      }
    }

    return <Ride>[];
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

// Tài xế đồng ý hủy chuyến xe
  // POST /api/v1/driver/ride/{rideId}/cancel-respond
  // ============================================================
  Future<(bool, String)> driverCancelRespond({
    required dynamic rideId,
    required bool agreement,
  }) async {
    final BaseResponse response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_DRIVER_RIDE_CANCEL_RESPOND(rideId),
      headers: await _authHeader(),
      body: {
        "agreement": agreement,
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

  // ============================================================
  // Tài xế sẵn sàng sau khi hoan thanh chuyen
  // POST /api/v1/driver/ride/{rideId}/confirm-ready
  // ============================================================
  Future<(bool, String)> confirmReady(dynamic rideId) async {
    final BaseResponse response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_DRIVER_RIDE_CONFIRM_READY(rideId),
      headers: await _authHeader(),
    );
    return (response.isSuccess, response.message ?? "");
  }

  // ============================================================
  // Tài xế sẵn sàng sau khi hoan thanh chuyen
  // POST /api/v1/driver/ride/{rideId}/confirm-ready
  // ============================================================
  Future<(bool, String, RideIncomeSummary)> getIncomeSummary(
      dynamic rideId) async {
    final BaseResponse response = await ApiUtil.getInstance()!.get(
      url: ApiEndPoint.DOMAIN_DRIVER_RIDE_INCOME_SUMMARY(rideId),
      headers: await _authHeader(),
    );
    RideIncomeSummary rideIncomeSummary = RideIncomeSummary();
    if (response.isSuccess && response.data != null) {
      try {
        final data = response.data['data'] ?? response.data;
        return (
          true,
          response.message ?? "",
          RideIncomeSummary.fromJson(data as Map<String, dynamic>)
        );
      } catch (e) {
        print('❌ getIncomeSummary parse error: $e');
      }
    }
    return (response.isSuccess, response.message ?? "", rideIncomeSummary);
  }

  Future<(bool, List<Ride>)> getScheduledRides({
    String? travelDate,
    String? travelTime,
    int? rideType,
    num? minPrice,
    num? maxPrice,
  }) async {
    try {
      final params = <String, dynamic>{};
      if (travelDate != null && travelDate.isNotEmpty) {
        params['travel_date'] = travelDate;
      }
      if (travelTime != null && travelTime.isNotEmpty) {
        params['travel_time'] = travelTime;
      }
      if (rideType != null) {
        params['ride_type'] = rideType;
      }
      if (minPrice != null) {
        params['min_price'] = minPrice;
      }
      if (maxPrice != null) {
        params['max_price'] = maxPrice;
      }

      final BaseResponse response = await ApiUtil.getInstance()!.get(
        url: ApiEndPoint.DOMAIN_DRIVER_SCHEDULED_RIDES,
        params: params,
        headers: await _authHeader(),
      );

      if (response.isSuccess && response.data != null) {
        return (true, _parseRideList(response.data));
      }

      return (false, <Ride>[]);
    } catch (e, stack) {
      print('❌ getScheduledRides error: $e');
      print('Stack trace: $stack');
      return (false, <Ride>[]);
    }
  }

  Future<(bool, Ride?)> getScheduledRideDetail(dynamic rideId) async {
    try {
      final BaseResponse response = await ApiUtil.getInstance()!.get(
        url: ApiEndPoint.DOMAIN_DRIVER_SCHEDULED_RIDE_DETAIL(rideId),
        headers: await _authHeader(),
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data['data'] ?? response.data;
        final ride = _parseRide(
          data is Map<String, dynamic> && data['ride'] is Map<String, dynamic>
              ? data['ride']
              : data,
        );
        return (ride != null, ride);
      }

      return (false, null);
    } catch (e, stack) {
      print('❌ getScheduledRideDetail error: $e');
      print('Stack trace: $stack');
      return (false, null);
    }
  }

  Future<(bool, Ride?)> acceptScheduledRide(dynamic rideId) async {
    try {
      final BaseResponse response = await ApiUtil.getInstance()!.post(
        url: ApiEndPoint.DOMAIN_DRIVER_SCHEDULED_RIDE_ACCEPT(rideId),
        headers: await _authHeader(),
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data['data'] ?? response.data;
        final ride = _parseRide(
          data is Map<String, dynamic> && data['ride'] is Map<String, dynamic>
              ? data['ride']
              : data,
        );
        return (true, ride);
      }

      return (false, null);
    } catch (e, stack) {
      print('❌ acceptScheduledRide error: $e');
      print('Stack trace: $stack');
      return (false, null);
    }
  }

  Future<(bool, Ride?)> cancelScheduledRide(dynamic rideId) async {
    try {
      final BaseResponse response = await ApiUtil.getInstance()!.post(
          url: ApiEndPoint.DOMAIN_DRIVER_SCHEDULED_RIDE_CANCEL(rideId),
          headers: await _authHeader(),
          body: {"reason": "Hủy chuyến"});

      if (response.isSuccess && response.data != null) {
        final data = response.data['data'] ?? response.data;
        final ride = _parseRide(
          data is Map<String, dynamic> && data['ride'] is Map<String, dynamic>
              ? data['ride']
              : data,
        );
        return (true, ride);
      }

      return (false, null);
    } catch (e, stack) {
      print('❌ cancelScheduledRide error: $e');
      print('Stack trace: $stack');
      return (false, null);
    }
  }

  Future<(bool, List<Ride>)> getManagedRides() async {
    try {
      final BaseResponse response = await ApiUtil.getInstance()!.get(
        url: ApiEndPoint.DOMAIN_DRIVER_MANAGED_RIDES,
        headers: await _authHeader(),
      );

      if (response.isSuccess && response.data != null) {
        return (true, _parseRideList(response.data));
      }

      return (false, <Ride>[]);
    } catch (e, stack) {
      print('❌ getManagedRides error: $e');
      print('Stack trace: $stack');
      return (false, <Ride>[]);
    }
  }
}
