import 'package:demo_app/main/base/base_response.dart';
import 'package:demo_app/main/data/api/api_interceptors.dart';
import 'package:demo_app/main/utils/device_utils.dart';
import 'package:dio/dio.dart';

class ApiUtil {
  bool IS_SHOW_LOG = false;
  Dio? dio;
  static ApiUtil? _mInstance;
  CancelToken cancelToken = CancelToken();

  static ApiUtil? getInstance() {
    _mInstance ??= ApiUtil();
    return _mInstance;
  }

  ApiUtil() {
    if (dio == null) {
      dio = Dio();
      dio!.options.connectTimeout = const Duration(seconds: 60);
      dio!.options.receiveTimeout = const Duration(seconds: 60);
      dio!.options.headers = {
        "Accept-language": "en",
        "device-type": DeviceUtils.getPlatform(),
        "app-revision": 123,
        "app-version": DeviceUtils.getVersion(),
        "push-id": "",
        "app-provision": DeviceUtils.getPackageName(),
        "os-version": DeviceUtils.getOSVersion(),
        "device-name": DeviceUtils.getDeviceName(),
        'Content-Type': 'application/json',
        'Accept': 'application/json', // ← Header quan trọng nhất
        'X-Requested-With': 'XMLHttpRequest',
      };
      dio!.options.persistentConnection = false;
      dio!.interceptors.add(ApiInterceptors(dio!));
      dio!.interceptors.add(RetryOnConnectionChangeInterceptor(dio: dio!));
    }
  }

  Future<BaseResponse> get({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic> params = const {},
    Map<String, dynamic>? headers,
    String contentType = Headers.jsonContentType,
  }) async {
    try {
      var response = await dio!.get(url,
          queryParameters: params,
          data: body,
          options: Options(
            headers: headers,
            persistentConnection: false,
            contentType: contentType,
          ),
          cancelToken: cancelToken);
      return getBaseResponse(response);
    } catch (error) {
      return BaseResponse.error(error.toString());
    }
  }

  Future<BaseResponse> post({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic> params = const {},
    Map<String, dynamic>? headers = const {
      'Content-Type': 'application/json',
      'Accept': 'application/json', // ← Header quan trọng nhất
      'X-Requested-With': 'XMLHttpRequest', // Thêm cái này nữa cho an toàn
    },
    String contentType = Headers.jsonContentType,
  }) async {
    try {
      var response = await dio!.post(url,
          queryParameters: params,
          data: body,
          options: Options(
              headers: headers,
              responseType: ResponseType.json,
              contentType: contentType,
              persistentConnection: false,
              validateStatus: (status) {
                return status! < 500;
              },
              followRedirects: false),
          cancelToken: cancelToken);

      print("tu dio: ${response.data}");
      return getBaseResponse(response);
    } catch (error) {
      return BaseResponse.error(error.toString());
    }
  }

  Future<BaseResponse> put({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic> params = const {},
    Map<String, dynamic>? headers,
    String contentType = Headers.jsonContentType,
  }) async {
    try {
      final response = await dio!.put(
        url,
        queryParameters: params,
        data: body,
        options: Options(
          headers: headers,
          responseType: ResponseType.json,
          contentType: contentType,
          persistentConnection: false,
        ),
        cancelToken: cancelToken,
      );
      return getBaseResponse(response);
    } catch (error) {
      return BaseResponse.error(error.toString());
    }
  }

  Future<BaseResponse> delete({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic> params = const {},
    Map<String, dynamic>? headers,
    String contentType = Headers.jsonContentType,
  }) async {
    try {
      final response = await dio!.delete(
        url,
        queryParameters: params,
        data: body,
        options: Options(
          headers: headers,
          responseType: ResponseType.json,
          contentType: contentType,
          persistentConnection: false,
        ),
        cancelToken: cancelToken,
      );
      return getBaseResponse(response);
    } catch (error) {
      return BaseResponse.error(error.toString());
    }
  }

  Future<T> getParsed<T>({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic> params = const {},
    Map<String, dynamic>? headers,
    String contentType = Headers.jsonContentType,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await dio!.get(
        url,
        queryParameters: params,
        data: body,
        options: Options(
          headers: headers,
          contentType: contentType,
          persistentConnection: false,
        ),
        cancelToken: cancelToken,
      );

      return fromJson(response.data);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<T> postParsed<T>({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic> params = const {},
    Map<String, dynamic>? headers,
    String contentType = Headers.jsonContentType,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await dio!.post(
        url,
        queryParameters: params,
        data: body,
        options: Options(
          headers: headers,
          responseType: ResponseType.json,
          contentType: contentType,
          persistentConnection: false,
        ),
        cancelToken: cancelToken,
      );

      return fromJson(response.data);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<T> putParsed<T>({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic> params = const {},
    Map<String, dynamic>? headers,
    String contentType = Headers.jsonContentType,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await dio!.put(
        url,
        queryParameters: params,
        data: body,
        options: Options(
          headers: headers,
          responseType: ResponseType.json,
          contentType: contentType,
          persistentConnection: false,
        ),
        cancelToken: cancelToken,
      );

      return fromJson(response.data);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<T> deleteParsed<T>({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic> params = const {},
    Map<String, dynamic>? headers,
    String contentType = Headers.jsonContentType,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await dio!.delete(
        url,
        queryParameters: params,
        data: body,
        options: Options(
          headers: headers,
          responseType: ResponseType.json,
          contentType: contentType,
          persistentConnection: false,
        ),
        cancelToken: cancelToken,
      );

      return fromJson(response.data);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  BaseResponse getBaseResponse(Response response) {
    return BaseResponse.success(
        data: response.data ?? "",
        code: response.data['code'],
        message: response.data['message'],
        success: response.data['success'],
        status: response.data['status']);
  }
}
