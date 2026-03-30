import 'package:demo_app/res/app_colors.dart';
import 'package:flutter/material.dart';

class LoadingOverlayWidget {
  static final _overlayEntry = ValueNotifier<OverlayEntry?>(null);

  static void show(BuildContext context) {
    if (_overlayEntry.value != null) return;

    _overlayEntry.value = OverlayEntry(
      builder: (context) => Stack(
        children: [
          ModalBarrier(
            color: AppColors.color_1618.withValues(alpha: 0.5),
            dismissible: false,
          ),
          const Center(
            child: CircularProgressIndicator(
              color: AppColors.color_E11B,
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry.value!);
  }

  static void hide() {
    _overlayEntry.value?.remove();
    _overlayEntry.value = null;
  }
}
