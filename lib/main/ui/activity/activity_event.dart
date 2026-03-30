part of 'activity_bloc.dart';

abstract class ActivityEvent {}

class LoadActivityEvent extends ActivityEvent {}

class TabChangedEvent extends ActivityEvent {
  final int tabIndex;
  TabChangedEvent(this.tabIndex);
}
