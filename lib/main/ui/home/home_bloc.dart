import 'package:demo_app/main/data/model/goong/location.dart';
import 'package:demo_app/main/data/model/ride/ride.dart';
import 'package:demo_app/main/data/model/user/user.dart';
import 'package:demo_app/main/data/model/homepage/homepage.dart';
import 'package:demo_app/main/data/repository/homepage_repository.dart';
import 'package:demo_app/main/data/service/socket_service/approval_socket_service.dart';
import 'package:demo_app/main/data/service/socket_service/driver_socket_service.dart';
import 'package:demo_app/main/data/service/socket_service/socket_service5.dart';
// import 'package:demo_app/main/data/service/socket_service/user_socket_service.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:demo_app/main/utils/constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SocketService _socketService = SocketService();

  HomeBloc() : super(HomeInitial()) {
    on<UpdateHomeAddressEvent>((event, emit) async {
      await SharePreferenceUtil.saveHomeAddress(event.location);
      emit((state as HomeLoadSuccess)
          .copyWith(homeAddress: event.location.description));
    });

    on<UpdateWorkAddressEvent>((event, emit) async {
      await SharePreferenceUtil.saveWorkAddress(event.location);
      emit((state as HomeLoadSuccess)
          .copyWith(workAddress: event.location.description));
    });

    on<HomeLoaded>((event, emit) async {
      final currentRide = await SharePreferenceUtil.getCurrentRide();
      final user = await SharePreferenceUtil.getUser();
      print("lay user tu share preference ${user?.toJson()}");
      final homeAddress = await SharePreferenceUtil.getHomeAddress();
      final workAddress = await SharePreferenceUtil.getWorkAddress();
      final (isSuccess, homePageData, message) =
          await HomePageRepository().getHomePageData();

      if (user != null) {
        emit(HomeLoadSuccess(
            user: user,
            homeData: homePageData,
            currentRide: currentRide,
            homeAddress: homeAddress?.description ?? "Thêm địa chỉ nhà",
            workAddress: workAddress?.description ?? "Thêm địa chỉ công ty"));
      } else {
        emit(HomeLoadFailure('Không tìm thấy thông tin người dùng'));
      }
      // khoi tao user socket service o man home
      // if (Constant.isUserApp) {
      //   print("khoi tao user socket service o home bloc");
      //   UserSocketService().init();
      //   if (currentRide != null) {
      //     UserSocketService().joinRide(currentRide.id ?? "");
      //   }
      // } else {
      print("khoi tao driver socket service o home bloc");
      DriverSocketService().init();
      if (currentRide != null) {
        DriverSocketService().joinRide(currentRide.id.toString());
      }
      // }
    });

    // khoi tao approval socket service o man home
    // print("khoi tao approval socket service o home bloc");
    // ApprovalSocketService().init();

    //  test va debug
    // connectToRealtime();
    // Khởi tạo Socket khi Bloc được tạo
    // print("bloc log bat dau khoi tao socket");
    // _socketService.init(rideId: "160443641809804273");
    // // Lắng nghe từ SocketService
    // _socketService.onApplicationApproved.listen((data) {
    //   // add(ApplicationApproved(data));
    //   print("data: $data");
    // });
  }

  // void _onApplicationApproved(ApplicationApproved event, Emitter<DriverState> emit) {
  //   emit(state.copyWith(isApproved: true));
  // }
}
