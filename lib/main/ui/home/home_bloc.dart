import 'package:demo_app/main/data/model/user/user.dart';
import 'package:demo_app/main/data/model/homepage/homepage.dart';
import 'package:demo_app/main/data/repository/homepage_repository.dart';
import 'package:demo_app/main/data/service/socket_service/approval_socket_service.dart';
import 'package:demo_app/main/data/service/socket_service/socket_service5.dart';
import 'package:demo_app/main/data/service/socket_service/user_socket_service.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SocketService _socketService = SocketService();
  HomeBloc() : super(HomeInitial()) {
    on<HomeLoaded>((event, emit) async {
      final user = await SharePreferenceUtil.getUser();
      print("lay user tu share preference ${user?.toJson()}");

      final (isSuccess, homePageData, message) =
          await HomePageRepository().getHomePageData();

      if (user != null) {
        emit(HomeLoadSuccess(user, homePageData));
      } else {
        emit(HomeLoadFailure('Không tìm thấy thông tin người dùng'));
      }
    });

    //khoi tao approval socket service o man home
    print("khoi tao approval socket service o home bloc");
    ApprovalSocketService().init();

    //khoi tao user socket service o man home
    print("khoi tao user socket service o home bloc");
    UserSocketService().init();
    UserSocketService().joinRide("160250722972294650");

    print("bloc log bat dau khoi tao socket");
    // connectToRealtime();
    // Khởi tạo Socket khi Bloc được tạo
    _socketService.init(rideId: "160250722972294650");
    // Lắng nghe từ SocketService
    _socketService.onApplicationApproved.listen((data) {
      // add(ApplicationApproved(data));
      print("data: $data");
    });
  }

  // void _onApplicationApproved(ApplicationApproved event, Emitter<DriverState> emit) {
  //   emit(state.copyWith(isApproved: true));
  // }
}
