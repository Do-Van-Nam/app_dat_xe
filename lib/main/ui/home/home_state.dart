part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoadSuccess extends HomeState {
  final User user;
  HomeLoadSuccess(this.user);
}

class HomeLoadFailure extends HomeState {
  final String error;
  HomeLoadFailure(this.error);
}
