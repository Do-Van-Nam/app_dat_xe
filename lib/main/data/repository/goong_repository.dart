import 'package:demo_app/main/data/api/api_end_point.dart';
import 'package:demo_app/main/data/api/api_util.dart';
import 'package:demo_app/main/data/model/goong/location.dart';
import 'package:demo_app/main/data/model/goong/place_detail.dart';

class GoongRepository {
  GoongRepository._();
  static final GoongRepository _instance = GoongRepository._();
  factory GoongRepository() => _instance;

  // Thay chuỗi này bằng API key thực tế của bạn hoặc lấy từ Config
  // Tốt nhất nên cấu hình biến môi trường hoặc file config riêng
  static const String _goongApiKey = 'nyVhuiUNsZl54qCI9eYVCNpN43qUa1SEuMui6KVS';

  // ============================================================
  // Lấy gợi ý địa điểm (Autocomplete)
  // ============================================================

  /// Gọi API tới Goong để lấy danh sách gợi ý địa điểm dựa trên từ khóa tìm kiếm.
  ///
  /// [input]: Từ khóa tìm kiếm (bắt buộc)
  /// [latitude], [longitude]: Tọa độ hiện tại (tùy chọn, dùng để ưu tiên kết quả gần vị trí này)
  /// [limit]: Số lượng kết quả trả về tối đa (mặc định 10)
  /// [radius]: Bán kính tìm kiếm ưu tiên tính bằng km (mặc định 10)
  Future<(bool, List<GoongLocation>)> getAutocompletePlaces({
    required String input,
    double? latitude,
    double? longitude,
    int limit = 10,
    int radius = 50,
  }) async {
    try {
      final Map<String, dynamic> params = {
        'input': input,
        'limit': limit.toString(),
        'radius': radius.toString(),
        'api_key': _goongApiKey,
      };

      if (latitude != null && longitude != null) {
        params['location'] = '$latitude,$longitude';
      }

      // Do API của Goong trả về list trong field 'predictions' chứ không phải chuẩn BaseResponse theo format của server backend.
      // Dùng getParsed thay vì gọi ApiUtil.get() thông thường do format Response khác.

      final response =
          await ApiUtil.getInstance()!.getParsed<Map<String, dynamic>>(
        url: ApiEndPoint.DOMAIN_GOONG_PLACE_AUTOCOMPLETE,
        params: params,
        fromJson: (json) => json as Map<String, dynamic>,
      );

      // Theo format phổ biến của Google / Goong Maps API
      // Response có dạng { "predictions": [ ... ] } hoặc tương tự,
      final predictions = response['predictions'] as List<dynamic>?;

      if (predictions != null) {
        final List<GoongLocation> locations = predictions
            .map((e) => GoongLocation.fromJson(e as Map<String, dynamic>))
            .toList();
        return (true, locations);
      }

      return (false, <GoongLocation>[]);
    } catch (e, stackTrace) {
      print('❌ getAutocompletePlaces error: $e');
      print(stackTrace);
      return (false, <GoongLocation>[]);
    }
  }

  // ============================================================
  // Lấy chi tiết địa điểm (Place Detail)
  // ============================================================

  /// Gọi API tới Goong để lấy thông tin chi tiết của một địa điểm dựa trên `place_id`.
  ///
  /// [placeId]: ID của địa điểm (bắt buộc)
  Future<(bool, GoongPlaceDetail?)> getPlaceDetail({
    required String placeId,
  }) async {
    try {
      final Map<String, dynamic> params = {
        'place_id': placeId,
        'api_key': _goongApiKey,
      };

      final response =
          await ApiUtil.getInstance()!.getParsed<Map<String, dynamic>>(
        url: ApiEndPoint.DOMAIN_GOONG_PLACE_DETAIL,
        params: params,
        fromJson: (json) => json as Map<String, dynamic>,
      );

      // Theo format của Goong Maps API
      // Response có dạng { "result": { ... }, "status": "OK" }
      final result = response['result'] as Map<String, dynamic>?;
      final status = response['status'] as String?;

      if (status == 'OK' && result != null) {
        final placeDetail = GoongPlaceDetail.fromJson(result);
        return (true, placeDetail);
      }

      return (false, null);
    } catch (e, stackTrace) {
      print('❌ getPlaceDetail error: $e');
      print(stackTrace);
      return (false, null);
    }
  }
}
