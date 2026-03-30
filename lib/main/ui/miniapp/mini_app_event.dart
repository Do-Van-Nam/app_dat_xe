import 'dart:ui';

abstract class MiniAppEvent {}

class MiniAppOpen extends MiniAppEvent {}

class MiniAppMinimize extends MiniAppEvent {}

class MiniAppClose extends MiniAppEvent {}

class MiniAppUpdatePosition extends MiniAppEvent {
  final Offset position;
  MiniAppUpdatePosition(this.position);
}

class MiniAppNearCloseChanged extends MiniAppEvent {
  final bool value;
  MiniAppNearCloseChanged(this.value);
}

class MiniAppLoadUrl extends MiniAppEvent {
  final String url;
  MiniAppLoadUrl(this.url);
}