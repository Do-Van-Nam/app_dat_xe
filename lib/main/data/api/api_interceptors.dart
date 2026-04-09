import 'dart:convert';
import 'dart:io';
import 'package:demo_app/main/data/model/user_info_model.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:demo_app/main/utils/logger.dart';
import 'package:demo_app/router.dart';
import 'package:dio/dio.dart';

class ApiInterceptors extends InterceptorsWrapper {
  final Dio dio;
  String? token;
  ApiInterceptors(this.dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final method = options.method;
    final uri = options.uri;
    final data = options.data;

    if (token != null) {
      options.headers["Authorization"] = "Bearer $token";
    }

    AppLogger().logInfo(
      "\n-------------------------------------------------------------------\n ${options.headers["Authorization"]}",
    );
    if (method == 'GET') {
      AppLogger().logInfo(
        "✈️ REQUEST[$method] => PATH: $uri \n Token: ${options.headers}",
      );
    } else {
      try {
        AppLogger().logInfo(
          "✈️ REQUEST[$method] => PATH: $uri \n DATA: ${jsonEncode(data)}",
        );
      } catch (e) {
        AppLogger().logInfo("✈️ REQUEST[$method] => PATH: $uri \n DATA: $data");
      }
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final statusCode = response.statusCode;
    final uri = response.requestOptions.uri;
    final data = jsonEncode(response.data);
    AppLogger().logInfo("✅ RESPONSE[$statusCode] => PATH: $uri\n DATA: $data");
    if (response.statusCode == 401) {
      appForceLogout();
    }
    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final uri = err.requestOptions.path;
    var data = "";
    // if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
    if (err.response?.statusCode == 401) {
      // bool success = await _createToken();
      // if (success) {
      //   err.requestOptions.headers["Authorization"] = "Bearer $token";
      //
      //   // Gửi lại request với token mới
      //   final clonedRequest = await dio.fetch(err.requestOptions);
      //   return handler.resolve(clonedRequest);
      // }
      appForceLogout();
    }
    AppLogger().logInfo("⚠️ ERROR[$statusCode] => PATH: $uri\n DATA: $data");
    super.onError(err, handler);
  }

  Future<void> appForceLogout() async {
    await SharePreferenceUtil.removeKey(ShareKey.KEY_USER_INFO);
    await SharePreferenceUtil.removeKey(ShareKey.KEY_ACCESS_TOKEN);
    await SharePreferenceUtil.removeKey(ShareKey.KEY_REFRESH_TOKEN);
    await SharePreferenceUtil.removeKey(ShareKey.KEY_PHONE_NUMBER);
    UserInfoModel.instance.clear();
    router.pushReplacement(PATH_HOME);
  }

  // Hàm refresh token
  Future<bool> _createToken() async {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      // String md5 = "${UserInfo.instance.getToJid()}${UserInfo.instance.password}${timestamp}ringme";
      // String sec = Utilities.generateMd5(md5);
      // Response response = await dio.post(ApiEndPoint.API_JWT_TOKEN, queryParameters: {
      //   "username": UserInfo.instance.getToJid(),
      //   "timestamp": timestamp,
      //   "token": sec
      // });
      //
      // if (response.statusCode == 200) {
      //   token = response.data["data"];
      //   return true;
      // }
    } catch (e) {
      AppLogger().logError(e.toString());
    }
    return false;
  }
}

class RetryOnConnectionChangeInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries = 2;
  int retryCount = 0;

  RetryOnConnectionChangeInterceptor({required this.dio});

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (_shouldRetryOnHttpException(err)) {
      try {
        await dio
            .fetch<void>(err.requestOptions)
            .then((value) => handler.resolve(value));
      } on DioError catch (e) {
        super.onError(e, handler);
      }
    } else {
      super.onError(err, handler);
    }
  }

  bool _shouldRetryOnHttpException(DioError err) {
    retryCount++;

    var rs = (retryCount < maxRetries) &&
        err.type == DioErrorType.unknown &&
        ((err.error is HttpException &&
            (err.message ?? "").contains(
              'Connection closed before full header was received',
            )));
    if (!rs) {
      retryCount = 0;
    }

    return rs;
  }
}
