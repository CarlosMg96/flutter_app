part of 'road_cubit.dart';

@immutable
abstract class RoadState {}

class RoadInitial extends RoadState {}

class RoadLoading extends RoadState {}

class RoadLoaded extends RoadState {
  final List<Road> roads;

  RoadLoaded(this.roads);
}

class RoadDetailLoaded extends RoadState {
  final Road road;

  RoadDetailLoaded(this.road);
}

class RoadOperationSuccess extends RoadState {
  final String message;

  RoadOperationSuccess(this.message);
}

class RoadError extends RoadState {
  final String message;

  RoadError(this.message);
}
