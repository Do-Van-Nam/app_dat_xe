import 'package:intl/intl.dart';

class Constant {
  Constant._();
  // PAYMENT SEVICE
  static const bool isUserApp = true; //true: app người dùng, false: app tài xế
  static const bool isDebugMode = true;

  static const String TOPUP = "Top-up";
  static const String PROFILE = "profile";
  static const String TOPUP_V2 = "Topup";
  static const String FTTH = "FTTH";
  static const String LUCKY_SPIN = "VASLUCKYSPIN";
  static const String LUCKY_TOPUP = "VASTOPUPSPIN";
  static const String ABA_ACCOUNT = "ABA_ACCOUNT";
  static const String ABA_CARD = "ABA_CARD";
  static const String ABA_KHQR = "ABA_KHQR";
  static const String ABA_ACCOUNT_APP = "ABA_ACCOUNT_APP";
  static const String CREDIT_CARD = "CREDIT_CARD";
  static const String EMONEY = "eMoney";
  static const String EMONEY_WEB = "eMoney_web";
  static const String EMONEY_WEBVIEW = "EMONEY_WEBVIEW";
  static const String WING = "Wing";
  static const String WECHAT = "WECHAT";
  static const String ALIPAY = "Alipay";

  static const String WS_CODE = "wsGetOtpForCamIdDetail";

  static const String APPROVE = "APPROVED";
  static const String INIT = "INIT";
  static const String PENDING = "PENDING";
  static const String REJECT = "REJECTED";
  static const int SLIDER_HOME_TAB_MOBILE = 96;
  static const int SLIDER_HOME_TAB_INTERNET = 97;
  static const int SLIDER_METFONE_HEADER = 100;
  static const int SLIDER_METFONE_FOOTER = 101;
  static const int SLIDER_ENTERTAINMENT_HEADER = 98;
  static const int SLIDER_ENTERTAINMENT_FOOTER = 103;
  static const int TV360_TYPE = 360;
  static const int TAB_GAME_MF = 99;
  static const int VAS_SERVICE = 292;
  static const String MB = "MB";
  static const String GB = "GB";
  static const String MINS = "MINS";
  static const String SMS = "SMS";

  static const String FUNC_FTTH = "ftth";
  static const String FUNC_ESIM = "esim";
  static const String FUNC_MY_SERVICES = "my_services";
  static const String FUNC_PAYMENT_HISTORY = "payment_history";
  static const String FUNC_TOP_UP = "top_up";
  static const String FUNC_CHARGE_HISTORY = "charge_history";
  static const String FUNC_SCAN_CARD = "scan_card";
  static const String FUNC_ACCOUNT_DETAIL = "account_detail";

  static const String HISTORY_BASIC = "basic";
  static const String HISTORY_DATA = "data";
  static const String HISTORY_CALL = "call";
  static const String HISTORY_SMS = "sms";
  static const String HISTORY_ROAMING = "roaming";
  static const String HISTORY_OTHER = "other";
  static const String HISTORY_SERVICE = "service";

  static const int WS_DO_ACTION_SERVICE_ACTION_TYPE_REGISTER = 0;
  static const int WS_DO_ACTION_SERVICE_ACTION_TYPE_CANCEL = 1;
  static const String SUPER_EXCHANGE = "Super Exchange";

  static const String ACTIVATED = "Activated";
  static const String EXPIRED = "Account.STATUS.2.en";
  static const String SUSPENEDE = "Disabled";

  static const String TODAY = "TODAY";
  static const String WEEK = "7DAYS";
  static const String MONTH = "30DAYS";
  static const String CUSTOM = "CUSTOM";

  static const String UPDATE = "UPDATE";

  static String normalizePhone(String phone) {
    String p = phone.trim();

    if (p.startsWith('+855')) {
      p = p.substring(4);
    } else if (p.startsWith('855')) {
      p = p.substring(3);
    } else if (p.startsWith('0')) {
      p = p.substring(1);
    }

    return p;
  }

  static String normalizePhoneV2(String? phone) {
    if (phone == null || phone.isEmpty) return '';

    var result = phone.trim();

    if (result.startsWith('+855')) {
      result = result.replaceFirst('+855', '0');
    } else if (result.startsWith('855')) {
      result = result.replaceFirst('855', '0');
    } else if (!result.startsWith('0')) {
      result = '0$result';
    }

    return result;
  }

  static String formatNumber(double value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  static int parseTimestamp(String dayString) {
    if (dayString.isEmpty) {
      return DateTime.now().millisecondsSinceEpoch;
    }

    try {
      final parts = dayString.split('/');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      final utcDate = DateTime.utc(year, month, day);
      return utcDate.millisecondsSinceEpoch;
    } catch (_) {
      return DateTime.now().millisecondsSinceEpoch;
    }
  }

  static String formatDate(String? input) {
    try {
      if (input == null || input.isEmpty) return "";
      final inputFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
      final outputFormat = DateFormat("dd/MM/yyyy");

      final date = inputFormat.parse(input);
      return outputFormat.format(date);
    } catch (e) {
      return "";
    }
  }

  static String formatDateV2(int millis) => DateFormat('dd/MM/yyyy')
      .format(DateTime.fromMillisecondsSinceEpoch(millis));
}
