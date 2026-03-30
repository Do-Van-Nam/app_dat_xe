import 'dart:async';
import 'package:app_links/app_links.dart';

class DeeplinkService {
  static final DeeplinkService _instance = DeeplinkService._();
  factory DeeplinkService() => _instance;
  DeeplinkService._();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  void init({
    required Function(Uri uri) onDeepLink,
  }) {
    // App đang chạy
    _sub = _appLinks.uriLinkStream.listen(onDeepLink);

    // App mở từ trạng thái kill
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) {
        onDeepLink(uri);
      }
    });
  }

  void dispose() {
    _sub?.cancel();
  }
}
