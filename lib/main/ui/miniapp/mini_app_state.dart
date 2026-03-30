import 'dart:ui';

class MiniAppState {
  final bool opened;
  final bool minimized;
  final Offset position;
  final bool nearClose;

  const MiniAppState({
    this.opened = false,
    this.minimized = false,
    this.position = const Offset(20, 120),
    this.nearClose = false,
  });

  MiniAppState copyWith({
    bool? opened,
    bool? minimized,
    Offset? position,
    bool? nearClose,
  }) {
    return MiniAppState(
      opened: opened ?? this.opened,
      minimized: minimized ?? this.minimized,
      position: position ?? this.position,
      nearClose: nearClose ?? this.nearClose,
    );
  }
}
