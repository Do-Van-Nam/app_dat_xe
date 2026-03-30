part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoadSuccess extends HomeState {}

class HomeLoadFailure extends HomeState {
  final String error;
  HomeLoadFailure(this.error);
}
