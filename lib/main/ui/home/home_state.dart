part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoadSuccess extends HomeState {
  final User user;
  final HomePageModel? homeData;
  final Ride? currentRide;
  final String homeAddress;
  final String workAddress;
  HomeLoadSuccess(
      {required this.user,
      this.homeData,
      this.currentRide,
      required this.homeAddress,
      required this.workAddress});

  HomeLoadSuccess copyWith({
    User? user,
    HomePageModel? homeData,
    Ride? currentRide,
    String? homeAddress,
    String? workAddress,
  }) {
    return HomeLoadSuccess(
      user: user ?? this.user,
      homeData: homeData ?? this.homeData,
      currentRide: currentRide ?? this.currentRide,
      homeAddress: homeAddress ?? this.homeAddress,
      workAddress: workAddress ?? this.workAddress,
    );
  }
}

class HomeLoadFailure extends HomeState {
  final String error;
  HomeLoadFailure(this.error);
}
