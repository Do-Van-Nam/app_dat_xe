part of 'search_destination_bloc.dart';

@immutable
sealed class SearchDestinationState {}

final class SearchDestinationInitial extends SearchDestinationState {}

final class SearchDestinationLoading extends SearchDestinationState {}

final class SearchDestinationLoaded extends SearchDestinationState {
  final List<PopularDestination> popularDestinations;
  final List<RecentSearch> recentSearches;
  final String currentLocation;

  SearchDestinationLoaded({
    required this.popularDestinations,
    required this.recentSearches,
    this.currentLocation = "Vị trí của bạn",
  });
}

final class SearchDestinationError extends SearchDestinationState {
  final String message;
  SearchDestinationError(this.message);
}

// Models
class PopularDestination {
  final String id;
  final String name;
  final String distance;
  final String address;

  PopularDestination({
    required this.id,
    required this.name,
    required this.distance,
    required this.address,
  });
}

class RecentSearch {
  final String id;
  final String name;
  final String address;

  RecentSearch({
    required this.id,
    required this.name,
    required this.address,
  });
}
