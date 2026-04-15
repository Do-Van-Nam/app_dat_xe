import 'package:demo_app/main/data/model/user/user.dart';
import 'package:demo_app/main/data/model/homepage/homepage.dart';
import 'package:demo_app/main/data/repository/homepage_repository.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeLoaded>((event, emit) async {
      final user = await SharePreferenceUtil.getUser();
      print("lay user tu share preference ${user?.toJson()}");
      
      final (isSuccess, homePageData, message) = await HomePageRepository().getHomePageData();

      if (user != null) {
        emit(HomeLoadSuccess(user, homePageData));
      } else {
        emit(HomeLoadFailure('Không tìm thấy thông tin người dùng'));
      }
    });
  }
}
