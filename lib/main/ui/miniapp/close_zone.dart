import 'package:flutter/material.dart';

class CloseZone extends StatelessWidget {
  final bool visible;
  final bool active;
  final VoidCallback onClose;

  const CloseZone({
    super.key,
    required this.visible,
    required this.active,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: Center(
          child: AnimatedScale(
            scale: active ? 1.2 : 1,
            duration: const Duration(milliseconds: 150),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: active ? Colors.redAccent : Colors.red,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: onClose,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
