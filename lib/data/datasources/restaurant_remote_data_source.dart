// lib/data/datasources/restaurant_remote_data_source.dart
import '../models/restaurant_model.dart';

abstract class RestaurantRemoteDataSource {
  Future<List<RestaurantModel>> getRestaurantRecommendations(
    double userLat,
    double userLon, {
    int? limit,
    int? offset,
    double? radius,
  });

  Future<List<RestaurantModel>> searchRestaurants(
    String query, {
    int? limit,
    int? offset,
    double? userLat,
    double? userLon,
  });

  Future<RestaurantModel?> getRestaurantById(int id);
}
