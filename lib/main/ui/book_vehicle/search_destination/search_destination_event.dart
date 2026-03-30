part of 'search_destination_bloc.dart';

@immutable
sealed class SearchDestinationEvent {}

class LoadSearchDataEvent extends SearchDestinationEvent {}

class SearchQueryChangedEvent extends SearchDestinationEvent {
  final String query;
  SearchQueryChangedEvent(this.query);
}

class SaveLocationEvent extends SearchDestinationEvent {
  final String locationId;
  SaveLocationEvent(this.locationId);
}
