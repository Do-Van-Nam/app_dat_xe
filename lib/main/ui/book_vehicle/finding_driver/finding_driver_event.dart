part of 'finding_driver_bloc.dart';

abstract class FindingDriverEvent extends Equatable {
  const FindingDriverEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when the page is opened to start searching.
class FindingDriverStartSearch extends FindingDriverEvent {
  const FindingDriverStartSearch();
}

/// Triggered when user taps "Hủy tìm kiếm".
class FindingDriverCancelSearch extends FindingDriverEvent {
  const FindingDriverCancelSearch();
}

/// Internal event: a driver has been found.
class FindingDriverFound extends FindingDriverEvent {
  const FindingDriverFound();
}

/// Internal event: search timed out.
class FindingDriverTimeout extends FindingDriverEvent {
  const FindingDriverTimeout();
}
