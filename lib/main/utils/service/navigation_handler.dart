import 'dart:async';

import 'package:demo_app/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Centralized handler to queue navigation requests that arrive
/// before the app finishes splash logic (deeplink / FCM taps).
class NavigationHandler {
  NavigationHandler._();

  static final NavigationHandler instance = NavigationHandler._();

  bool _ready = false;
  final List<FutureOr<void> Function()> _pending = [];

  /// Mark app navigation ready (after splash resolved) and flush queue.
  void markReady() {
    if (_ready) return;
    _ready = true;
    // Drain on next microtask to let the current navigation settle.
    scheduleMicrotask(_drain);
  }

  /// Deeplink from app_links.
  void handleDeepLink(Uri uri) {
    if (uri.host == 'webview') {
      final rawUrl = uri.queryParameters['ref'];
      if (rawUrl == null || rawUrl.isEmpty) return;

      final decodedUrl = Uri.decodeComponent(rawUrl);
      _openWebView(decodedUrl);
    }
  }

  /// Data payload from FCM notification.
  void handleFcmData(Map<String, dynamic> data) {
    if (data.isEmpty) return;

    // Prefer explicit deeplink if provided.
    final deeplink = data['deeplink'] ?? data['link'];
    if (deeplink is String && deeplink.isNotEmpty) {
      final uri = Uri.tryParse(deeplink);
      if (uri != null) {
        handleDeepLink(uri);
        return;
      }
    }

    // Fallback: open webview by url/webview_url keys.
    final webUrl = data['webview_url'] ?? data['url'] ?? data['ref'];
    if (webUrl is String && webUrl.isNotEmpty) {
      _openWebView(webUrl);
    }
  }

  void _openWebView(String url) {
    final parsed = Uri.tryParse(url);
    if (parsed == null ||
        (parsed.scheme != 'http' && parsed.scheme != 'https')) {
      return;
    }

    void action() {
      // Mini app overlay lives under ShellRoute; use root context to dispatch.
      final ctx = router.routerDelegate.navigatorKey.currentContext;
      if (ctx == null) return;

      
    }

    if (_ready) {
      action();
    } else {
      _pending.add(action);
    }
  }

  void _drain() {
    if (!_ready || _pending.isEmpty) return;
    final queue = List<FutureOr<void> Function()>.from(_pending);
    _pending.clear();
    for (final action in queue) {
      action();
    }
  }
}
