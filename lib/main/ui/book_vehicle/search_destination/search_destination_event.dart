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

class SavePickupLocationEvent extends SearchDestinationEvent {
  final GoongPlaceDetail pickupLocation;
  SavePickupLocationEvent(this.pickupLocation);
}

class SaveDestinationLocationEvent extends SearchDestinationEvent {
  final GoongPlaceDetail destinationLocation;
  SaveDestinationLocationEvent(this.destinationLocation);
}

class SavePickupPlaceIdEvent extends SearchDestinationEvent {
  final String pickupPlaceId;
  SavePickupPlaceIdEvent(this.pickupPlaceId);
}

class SaveDestinationPlaceIdEvent extends SearchDestinationEvent {
  final String destinationPlaceId;
  SaveDestinationPlaceIdEvent(this.destinationPlaceId);
}

class SubmitSearchEvent extends SearchDestinationEvent {
  final String pickupPlaceId;
  final String destinationPlaceId;
  final Function(GoongPlaceDetail, GoongPlaceDetail) onSuccess;
  SubmitSearchEvent({
    required this.pickupPlaceId,
    required this.destinationPlaceId,
    required this.onSuccess,
  });
}

/// Trigger lấy vị trí GPS + geocoding địa chỉ hiện tại
class FetchCurrentLocationEvent extends SearchDestinationEvent {}
