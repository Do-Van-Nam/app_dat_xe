import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'search_destination_event.dart';
part 'search_destination_state.dart';

class SearchDestinationBloc
    extends Bloc<SearchDestinationEvent, SearchDestinationState> {
  SearchDestinationBloc() : super(SearchDestinationInitial()) {
    on<LoadSearchDataEvent>(_onLoadData);
    on<SearchQueryChangedEvent>(_onSearchQueryChanged);
    on<SaveLocationEvent>(_onSaveLocation);
  }

  Future<void> _onLoadData(
      LoadSearchDataEvent event, Emitter<SearchDestinationState> emit) async {
    emit(SearchDestinationLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 700));

      final popular = [
        PopularDestination(
          id: "1",
          name: "Lotte Mall West Lake Hà Nội",
          distance: "6km",
          address: "272 Võ Chí Công, P.Phú Thượng, Q.Tây Hồ, Hà Nội",
        ),
        PopularDestination(
          id: "2",
          name: "Quảng trường Ba Đình",
          distance: "6,5km",
          address: "Hùng Vương, P.Diện Biên, Q.Ba Đình, Hà Nội",
        ),
        PopularDestination(
          id: "3",
          name: "Văn Miếu Quốc Tử Giám",
          distance: "7km",
          address: "58 Quốc Tử Giám, P.Văn Miếu, Q.Đống Đa, Hà Nội",
        ),
        PopularDestination(
          id: "4",
          name: "Di Tích Nhà Tù Hỏa Lò",
          distance: "8km",
          address: "1 Hỏa Lò, P.Trần Hưng Đạo, Q.Hoàn Kiếm, Hà Nội",
        ),
      ];

      final recent = [
        RecentSearch(
          id: "r1",
          name: "Bitexco Financial Tower",
          address: "2 Hải Triều, Bến Nghé, Quận 1",
        ),
        RecentSearch(
          id: "r2",
          name: "Landmark 81",
          address: "720A Điện Biên Phủ, Phường 22, Bình Thạnh",
        ),
      ];

      emit(SearchDestinationLoaded(
        popularDestinations: popular,
        recentSearches: recent,
      ));
    } catch (e) {
      emit(SearchDestinationError("Không thể tải dữ liệu"));
    }
  }

  void _onSearchQueryChanged(
      SearchQueryChangedEvent event, Emitter<SearchDestinationState> emit) {
    // Trong thực tế sẽ gọi API search, hiện tại chỉ giả lập
    if (state is SearchDestinationLoaded) {
      emit(SearchDestinationLoaded(
        popularDestinations:
            (state as SearchDestinationLoaded).popularDestinations,
        recentSearches: (state as SearchDestinationLoaded).recentSearches,
      ));
    }
  }

  void _onSaveLocation(
      SaveLocationEvent event, Emitter<SearchDestinationState> emit) {
    // TODO: Lưu vào danh sách yêu thích
    print("Saved location: ${event.locationId}");
  }
}
