import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/road_model.dart';
import '../config/config.dart';

class RoadRepository {
  Future<List<Road>> fetchRoads() async {
    final url = ApiConfig.getRoadsEndpoint;

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> roads = data['roads'];
        return roads.map((json) => Road.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load roads');
      }
    } catch (error) {
      throw Exception('Error fetching roads: $error');
    }
  }

  Future<void> addRoad(Road road) async {
    final url = ApiConfig.saveRoadsEndpoint;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(road.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to add road');
      }
    } catch (error) {
      throw Exception('Error adding road: $error');
    }
  }

  Future<void> updateRoad(Road road) async {
    final url = ApiConfig.updateRoadEndpoint;

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(road.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update road');
      }
    } catch (error) {
      throw Exception('Error updating road: $error');
    }
  }

  Future<void> deleteRoad(int id) async {
    final url = ApiConfig.deleteRoadEndpoint;

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': id}),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete road');
      }
    } catch (error) {
      throw Exception('Error deleting road: $error');
    }
  }
}
