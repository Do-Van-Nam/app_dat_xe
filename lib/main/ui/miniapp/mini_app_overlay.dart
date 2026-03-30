import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'close_zone.dart';
import 'floating_bubble.dart';
import 'mini_app_bloc.dart';
import 'mini_app_event.dart';
import 'mini_app_state.dart';
import 'mini_app_webview.dart';

class MiniAppOverlay extends StatelessWidget {
  const MiniAppOverlay({super.key});

  bool _nearClose(BuildContext c, Offset p) =>
      p.dy > MediaQuery.of(c).size.height - 180;

  Offset _snap(BuildContext c, Offset p) {
    final s = MediaQuery.of(c).size;
    final padding = MediaQuery.of(c).padding;
    final x = p.dx < s.width / 2 ? 8.0 : s.width - 56.0;
    final minY = padding.top + 80.0;
    final maxY = s.height - 200.0;
    return Offset(x, p.dy.clamp(minY, maxY));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MiniAppBloc, MiniAppState>(
      builder: (_, state) {
        return Stack(
          fit: StackFit.expand,
          children: [
            // WebView fullscreen khi opened và không minimized
            if (state.opened && !state.minimized)
              Positioned.fill(child: const MiniAppWebView()),

            // FloatingBubble khi minimized
            if (state.opened && state.minimized)
              FloatingBubble(
                position: state.position,
                nearClose: state.nearClose,
                onTap: () => context.read<MiniAppBloc>().add(MiniAppOpen()),
                onDragUpdate: (g) {
                  context.read<MiniAppBloc>().add(
                    MiniAppNearCloseChanged(_nearClose(context, g)),
                  );
                },
                onDragEnd: (p) {
                  if (_nearClose(context, p)) {
                    context.read<MiniAppBloc>().add(MiniAppClose());
                  } else {
                    context.read<MiniAppBloc>().add(
                      MiniAppUpdatePosition(_snap(context, p)),
                    );
                  }
                },
              ),

            // CloseZone khi minimized
            if (state.minimized && state.nearClose)
              CloseZone(
                visible: true,
                active: true,
                onClose: () => context.read<MiniAppBloc>().add(MiniAppClose()),
              ),
          ],
        );
      },
    );
  }
}
