import 'package:demo_app/main/data/api/api_end_point.dart';
import 'package:demo_app/main/data/api/api_util.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:demo_app/main/data/model/ride/ride.dart';
import 'package:demo_app/main/data/model/ride/vehicle.dart';
import 'package:demo_app/main/data/model/ride/price.dart';
import '../../base/base_response.dart';

class OperationRepository {
  OperationRepository._();
  static final OperationRepository _instance = OperationRepository._();
  factory OperationRepository() => _instance;
 
  Future<Map<String, String>> _authHeader() async {
    final token = await SharePreferenceUtil.getLoginToken();
    return {"Authorization": "Bearer $token"};
  }
 
  // ============================================================
  // Cập nhật vị trí
  // POST /api/v1/operation/location
  // ============================================================
  Future<bool> updateLocation(double lat, double lng) async {
    final BaseResponse response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_OPERATION_LOCATION,
      body: {"lat": lat, "lng": lng},
      headers: await _authHeader(),
    );
    return response.isSuccess;
  }
 
  // ============================================================
  // Lấy thông tin điều phối/dẫn đường
  // GET /api/v1/operation/navigation/{rideId}
  // ============================================================
  Future<(bool, dynamic)> getNavigation(dynamic rideId) async {
    final BaseResponse response = await ApiUtil.getInstance()!.get(
      url: ApiEndPoint.DOMAIN_OPERATION_NAVIGATION(rideId),
      headers: await _authHeader(),
    );
    if (response.isSuccess) {
      return (true, response.data['data'] ?? response.data);
    }
    return (false, null);
  }
}
