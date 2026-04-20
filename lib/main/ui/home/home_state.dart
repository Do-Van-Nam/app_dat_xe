part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoadSuccess extends HomeState {
  final User user;
  final HomePageModel? homeData;
  final Ride? currentRide;
  HomeLoadSuccess(this.user, this.homeData, this.currentRide);
}

class HomeLoadFailure extends HomeState {
  final String error;
  HomeLoadFailure(this.error);
}
