part of 'tai_xe_nhan_bloc.dart';

abstract class TripDetailEvent extends Equatable {
  const TripDetailEvent();

  @override
  List<Object?> get props => [];
}

/// User taps the more-options (⋯) button in AppBar.
class TripDetailMoreOptionsTapped extends TripDetailEvent {
  const TripDetailMoreOptionsTapped();
}

/// User taps "Gọi điện cho tài xế".
class TripDetailCallDriverTapped extends TripDetailEvent {
  const TripDetailCallDriverTapped();
}

/// User taps "Nhắn tin".
class TripDetailMessageDriverTapped extends TripDetailEvent {
  const TripDetailMessageDriverTapped();
}

/// User taps "Xem bản đồ trực tuyến".
class TripDetailViewMapTapped extends TripDetailEvent {
  const TripDetailViewMapTapped();
}

/// User taps "Hủy chuyến".
class TripDetailCancelTapped extends TripDetailEvent {
  const TripDetailCancelTapped();
}

/// User confirms cancellation in the dialog.
class TripDetailCancelConfirmed extends TripDetailEvent {
  const TripDetailCancelConfirmed();
}
