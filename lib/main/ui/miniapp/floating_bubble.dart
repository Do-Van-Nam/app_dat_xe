import 'package:flutter/material.dart';

class FloatingBubble extends StatefulWidget {
  final Offset position;
  final bool nearClose;
  final Function(Offset) onDragUpdate;
  final Function(Offset) onDragEnd;
  final VoidCallback onTap;

  const FloatingBubble({
    super.key,
    required this.position,
    required this.nearClose,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onTap,
  });

  @override
  State<FloatingBubble> createState() => _FloatingBubbleState();
}

class _FloatingBubbleState extends State<FloatingBubble> {
  Offset _currentPosition = Offset.zero;
  bool _isDragging = false;
  Offset _dragStartPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _currentPosition = widget.position;
  }

  @override
  void didUpdateWidget(FloatingBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.position != oldWidget.position && !_isDragging) {
      _currentPosition = widget.position;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _currentPosition.dx,
      top: _currentPosition.dy,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.onTap,
        onPanStart: (_) {
          _isDragging = true;
        },
        onPanUpdate: (details) {
          setState(() {
            _currentPosition += details.delta;
          });

          widget.onDragUpdate(details.globalPosition);
        },
        onPanEnd: (_) {
          _isDragging = false;
          widget.onDragEnd(_currentPosition);
        },
        child: _icon(),
      )
    );
  }

  Widget _icon() {
    return AnimatedScale(
      scale: widget.nearClose ? 1.2 : 1,
      duration: const Duration(milliseconds: 150),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.apps, color: Colors.white),
      ),
    );
  }
}
