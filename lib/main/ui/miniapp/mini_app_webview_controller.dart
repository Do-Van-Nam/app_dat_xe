import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MiniAppWebViewController {
  MiniAppWebViewController._internal();
  static final MiniAppWebViewController _instance =
      MiniAppWebViewController._internal();

  factory MiniAppWebViewController() => _instance;

  WebViewController? _controller;
  bool _inited = false;

  WebViewController get controller {
    if (!_inited || _controller == null) {
      throw StateError(
        'MiniAppWebViewController has not been initialized. '
        'Call init(BuildContext) first.',
      );
    }
    return _controller!;
  }

  bool get isInitialized => _inited && _controller != null;

  void init(BuildContext context) {
    if (_inited) return;

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://www.24h.com.vn/'));

    _inited = true;
  }

  void loadUrl(String url) {
    if (!isInitialized) {
      // Initialize with default settings if not already initialized
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted);
      _inited = true;
    }
    _controller!.loadRequest(Uri.parse(url));
  }
}
