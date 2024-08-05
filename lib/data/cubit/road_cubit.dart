import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../model/road_model.dart';
import '../repository/road_repository.dart';

part 'road_state.dart';

class RoadCubit extends Cubit<RoadState> {
  final RoadRepository _repository;

  RoadCubit(this._repository) : super(RoadInitial());

  Future<void> fetchRoads() async {
    emit(RoadLoading());
    try {
      final roads = await _repository.fetchRoads();
      emit(RoadLoaded(roads));
    } catch (error) {
      emit(RoadError('Failed to load roads: $error'));
    }
  }



  Future<void> createRoad(Road road) async {
    emit(RoadLoading());
    try {
      await _repository.addRoad(road);
      emit(RoadOperationSuccess('Road created successfully'));
      fetchRoads();  // Refresh list
    } catch (error) {
      emit(RoadError('Failed to create road: $error'));
    }
  }

  Future<void> updateRoad(Road road) async {
    emit(RoadLoading());
    try {
      await _repository.updateRoad(road);
      emit(RoadOperationSuccess('Road updated successfully'));
      fetchRoads();  // Refresh list
    } catch (error) {
      emit(RoadError('Failed to update road: $error'));
    }
  }

  Future<void> deleteRoad(int id) async {
    emit(RoadLoading());
    try {
      await _repository.deleteRoad(id);
      emit(RoadOperationSuccess('Road deleted successfully'));
      fetchRoads();  // Refresh list
    } catch (error) {
      emit(RoadError('Failed to delete road: $error'));
    }
  }
}
