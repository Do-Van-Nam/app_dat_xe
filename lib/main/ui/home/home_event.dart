part of 'home_bloc.dart';

abstract class HomeEvent {}

class HomeLoaded extends HomeEvent {}

class UpdateHomeAddressEvent extends HomeEvent {
  final GoongLocation location;
  UpdateHomeAddressEvent({required this.location});
}

class UpdateWorkAddressEvent extends HomeEvent {
  final GoongLocation location;
  UpdateWorkAddressEvent({required this.location});
}
