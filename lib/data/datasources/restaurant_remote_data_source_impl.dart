// lib/data/datasources/restaurant_remote_data_source_impl.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config.dart';
import '../models/restaurant_model.dart';
import 'restaurant_remote_data_source.dart';

class RestaurantRemoteDataSourceImpl implements RestaurantRemoteDataSource {
  final http.Client client;

  RestaurantRemoteDataSourceImpl({required this.client});

  @override
  Future<List<RestaurantModel>> getRestaurantRecommendations(
    double userLat,
    double userLon, {
    int? limit,
    int? offset,
    double? radius,
  }) async {
    final String params = _buildParams(userLat, userLon, limit, offset, radius);
    final response = await client.get(
      Uri.parse('${Config.baseUrl}/api/restaurants/recommendations?$params'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final List<dynamic> data = responseBody['data'];

      return data.map((json) => RestaurantModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load restaurants: ${response.statusCode}');
    }
  }

  @override
  Future<List<RestaurantModel>> searchRestaurants(
    String query, {
    int? limit,
    int? offset,
    double? userLat,
    double? userLon,
  }) async {
    String params = 'q=$query';
    if (limit != null) {
      params += '&limit=$limit';
    }
    if (offset != null) {
      params += '&offset=$offset';
    }
    if (userLat != null && userLon != null) {
      params += '&user_lat=$userLat&user_lon=$userLon';
    }

    final response = await client.get(
      Uri.parse('${Config.baseUrl}/api/restaurants/search?$params'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final List<dynamic> data = responseBody['data'];

      return data.map((json) => RestaurantModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search restaurants: ${response.statusCode}');
    }
  }

  @override
  Future<RestaurantModel?> getRestaurantById(int id) async {
    final response = await client.get(
      Uri.parse('${Config.baseUrl}/api/restaurants/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return RestaurantModel.fromJson(responseBody['data']);
    } else {
      throw Exception('Failed to load restaurant: ${response.statusCode}');
    }
  }

  String _buildParams(
    double userLat,
    double userLon,
    int? limit,
    int? offset,
    double? radius,
  ) {
    String params = 'user_lat=$userLat&user_lon=$userLon';
    if (limit != null) {
      params += '&limit=$limit';
    }
    if (offset != null) {
      params += '&offset=$offset';
    }
    if (radius != null) {
      params += '&radius=$radius';
    }
    return params;
  }
}
