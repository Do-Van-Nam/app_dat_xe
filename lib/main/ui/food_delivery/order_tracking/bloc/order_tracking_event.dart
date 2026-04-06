part of 'order_tracking_bloc.dart';

abstract class OrderTrackingEvent extends Equatable {
  const OrderTrackingEvent();

  @override
  List<Object?> get props => [];
}

/// Simulate the order progressing to the next step.
class OrderStepAdvanced extends OrderTrackingEvent {
  const OrderStepAdvanced();
}

/// User taps the back / notification button.
class NotificationTapped extends OrderTrackingEvent {
  const NotificationTapped();
}

/// User taps "Gọi" to call the driver.
class CallDriverTapped extends OrderTrackingEvent {
  const CallDriverTapped();
}

/// User taps "Chat" to open chat.
class ChatDriverTapped extends OrderTrackingEvent {
  const ChatDriverTapped();
}

/// User taps "Sửa" to edit delivery address.
class EditAddressTapped extends OrderTrackingEvent {
  const EditAddressTapped();
}

/// User taps a bottom navigation tab.
class NavTabChanged extends OrderTrackingEvent {
  final NavTab tab;
  const NavTabChanged(this.tab);

  @override
  List<Object?> get props => [tab];
}

/// Map recenter button tapped.
class RecenterMapTapped extends OrderTrackingEvent {
  const RecenterMapTapped();
}
