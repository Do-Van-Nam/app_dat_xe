part of 'search_destination_bloc.dart';

@immutable
sealed class SearchDestinationState {}

final class SearchDestinationInitial extends SearchDestinationState {}

final class SearchDestinationSubmit extends SearchDestinationState {
  final GoongPlaceDetail pickupLocation;
  final GoongPlaceDetail destinationLocation;
  SearchDestinationSubmit({
    required this.pickupLocation,
    required this.destinationLocation,
  });
}

final class SearchDestinationLoading extends SearchDestinationState {}

final class SearchDestinationLoaded extends SearchDestinationState {
  final List<PopularDestination> popularDestinations;
  final List<RecentSearch> recentSearches;
  final String currentLocation;
  final bool isLoadingLocation;
  // Cho kết quả tìm kiếm Goong Maps
  final List<GoongLocation> searchResults;
  final bool isSearching;
  final GoongPlaceDetail? pickupLocation;
  final GoongPlaceDetail? destinationLocation;
  final String? pickupPlaceId;
  final String? destinationPlaceId;
  final String? submitMessage;

  SearchDestinationLoaded({
    required this.popularDestinations,
    required this.recentSearches,
    this.currentLocation = "Vị trí của bạn",
    this.isLoadingLocation = false,
    this.searchResults = const [],
    this.isSearching = false,
    this.pickupLocation,
    this.destinationLocation,
    this.pickupPlaceId,
    this.destinationPlaceId,
    this.submitMessage,
  });

  SearchDestinationLoaded copyWith({
    List<PopularDestination>? popularDestinations,
    List<RecentSearch>? recentSearches,
    String? currentLocation,
    bool? isLoadingLocation,
    List<GoongLocation>? searchResults,
    bool? isSearching,
    GoongPlaceDetail? pickupLocation,
    GoongPlaceDetail? destinationLocation,
    String? pickupPlaceId,
    String? destinationPlaceId,
    String? submitMessage,
  }) {
    return SearchDestinationLoaded(
      popularDestinations: popularDestinations ?? this.popularDestinations,
      recentSearches: recentSearches ?? this.recentSearches,
      currentLocation: currentLocation ?? this.currentLocation,
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      pickupPlaceId: pickupPlaceId ?? this.pickupPlaceId,
      destinationPlaceId: destinationPlaceId ?? this.destinationPlaceId,
      submitMessage: submitMessage ?? this.submitMessage,
    );
  }
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
  final String placeId;

  PopularDestination(
      {required this.id,
      required this.name,
      required this.distance,
      required this.address,
      this.placeId = "test"});
}

class RecentSearch {
  final String id;
  final String name;
  final String address;
  final String placeId;

  RecentSearch(
      {required this.id,
      required this.name,
      required this.address,
      this.placeId = "test"});
}
