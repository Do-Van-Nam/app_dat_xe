import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeLoaded>((event, emit) async {
      emit(HomeLoadSuccess());
      // Sau này có thể load data từ API, user info, promotions...
    });
  }
}
