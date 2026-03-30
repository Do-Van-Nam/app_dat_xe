import 'package:demo_app/main/base/base_response_v2.dart';
import 'package:demo_app/main/base/base_result.dart';
import 'package:demo_app/main/data/api/api_end_point.dart';
import 'package:demo_app/main/data/api/api_util.dart';
import 'package:demo_app/main/data/model/chatbot/chatbot_response_model.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:demo_app/main/utils/device_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ChatBotRepository {
  ChatBotRepository._();
  static final ChatBotRepository _instance = ChatBotRepository._();
  factory ChatBotRepository() => _instance;


  Future<ChatbotResponse> getReply({
    ///  required String chatId,
    required String buttonCallback,
    required String wsCode,
    required String question,
    String? language, // Nếu null thì lấy từ SharedPreference
    bool force = false,
  }) async {

    final isdn = await SharePreferenceUtil.getString(ShareKey.KEY_PHONE_NUMBER);
    final lang = language ?? await SharePreferenceUtil.getLanguageCode();
    final versionApp = await PackageInfo.fromPlatform().then((e) => e.version);
    final chatId = DeviceUtils.getDeviceId();
    final body = {
      // get-menu : khi nhan nut hoac ban dau,
      // faq-query question : khi chon hoac nhap noi dung gui len
      // suggest-menu  question :
      "wsCode": wsCode, // Hoặc dùng const WSCode.getMenu nếu bạn có enum
      "username": isdn,
      "apiKey": "123",
      "language": lang,
      "sessionId": "", // Nếu user login thì lấy từ storage
      "token": "",
      "versionApp": versionApp,
      "wsRequest": {
        "buttonCallback": buttonCallback,
        "chatId": chatId,
        "question": question,
      },
    };

    final result = await ApiUtil.getInstance()!
        .postParsed<BaseResponseV2<BaseResult<ChatbotResponse>>>(
          url: ApiEndPoint.DOMAIN_API,
             
          body: body,
          fromJson: (json) => BaseResponseV2.fromJson(
            json,
            (data) => BaseResult<ChatbotResponse>.fromJson(
              data,
              (ws) => ChatbotResponse.fromJson(ws),
            ),
          ),
        );

    if (result.isSuccess && result.result?.wsResponse != null) {
      final wsResponse = result.result!.wsResponse!;
      // Cache nếu cần
      // _menuCache[chatId] = wsResponse;
      return wsResponse;
    }

    throw Exception(result.errorMessage ?? 'GetMenu failed');
  }

  // Nếu cần clear cache (ví dụ khi logout hoặc thay đổi chatId)
  void clearCache() {
    // _menuCache.clear();
  }

  // Phương thức bổ sung nếu bạn muốn lấy full response (tương tự getMenuFullResponse trước đó)
  Future<BaseResponseV2<BaseResult<ChatbotResponse>>> getMenuFullResponse({
    required String chatId,
    String buttonCallback = 'list_language',
    String? language,
  }) async {
    final isdn = await SharePreferenceUtil.getString(ShareKey.KEY_PHONE_NUMBER);
    final lang = language ?? await SharePreferenceUtil.getLanguageCode();
    final versionApp = await PackageInfo.fromPlatform().then((e) => e.version);

    final body = {
      "wsCode": "get-menu",
      "username": isdn,
      "apiKey": "123",
      "language": lang,
      "sessionId": "",
      "token": "",
      "versionApp": versionApp,
      "wsRequest": {"buttonCallback": buttonCallback, "chatId": chatId},
    };

    return await ApiUtil.getInstance()!
        .postParsed<BaseResponseV2<BaseResult<ChatbotResponse>>>(
          url: ApiEndPoint.DOMAIN_API,
          body: body,
          fromJson: (json) => BaseResponseV2.fromJson(
            json,
            (data) => BaseResult<ChatbotResponse>.fromJson(
              data,
              (ws) => ChatbotResponse.fromJson(ws),
            ),
          ),
        );
  }
}
