import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'mini_app_bloc.dart';
import 'mini_app_event.dart';
import 'mini_app_webview_controller.dart';

class MiniAppWebView extends StatefulWidget {
  const MiniAppWebView({super.key});

  @override
  State<MiniAppWebView> createState() => _MiniAppWebViewState();
}

class _MiniAppWebViewState extends State<MiniAppWebView>
    with AutomaticKeepAliveClientMixin {
  final _webController = MiniAppWebViewController();

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _webController.init(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        // Xử lý back button của hệ thống - đóng webview
        context.read<MiniAppBloc>().add(MiniAppClose());
      },
      child: Stack(
        children: [
          WebViewWidget(controller: _webController.controller),
          // Icon close và minimize ở góc trên bên phải
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon minimize
                Material(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      context.read<MiniAppBloc>().add(MiniAppMinimize());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Icon close
                Material(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      context.read<MiniAppBloc>().add(MiniAppClose());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
