import 'package:demo_app/main/data/api/api_end_point.dart';
import 'package:demo_app/main/data/api/api_util.dart';
import 'package:demo_app/main/data/model/homepage/homepage.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';

class HomePageRepository {
  HomePageRepository._();
  static final HomePageRepository _instance = HomePageRepository._();
  factory HomePageRepository() => _instance;

  Future<(bool, HomePageModel?, String)> getHomePageData() async {
    final token = await SharePreferenceUtil.getLoginToken();

    final response = await ApiUtil.getInstance()!.get(
      url: ApiEndPoint.DOMAIN_HOME_PAGE,
      // If authorization is needed globally it's usually handled by Interceptors,
      // or we can pass token here if required:
      headers: {"Authorization": "Bearer $token"},
    );

    bool isSuccess = false;
    HomePageModel? model;
    String message = response.message ?? '';

    // Check response based on the same nested 'data' pattern if applicable,
    // or direct parse if the root is the object.
    // From JSON structure provided, it implies the root json contains "header", "services", etc.
    // If it's wrapped in { "data": { ... } } we handle it:
    if (response.data is Map<String, dynamic>) {
      final Map<String, dynamic> data = response.data;

      // Try to parse assuming standard structure where actual data might be inside 'data' key or root
      if (data.containsKey('success')) {
        isSuccess = data['success'] == true;
      } else {
        isSuccess = true; // Fallback if API doesn't return 'success' bool
      }

      if (data.containsKey('message') && data['message'] != null) {
        message = data['message'].toString();
      }

      if (data.containsKey('data') && data['data'] != null) {
        model = HomePageModel.fromJson(data['data']);
      } else {
        // If data is at the root
        try {
          model = HomePageModel.fromJson(data);
        } catch (e) {
          print("Error parsing HomePageModel: $e");
        }
      }
    }

    return (isSuccess, model, message);
  }
}
