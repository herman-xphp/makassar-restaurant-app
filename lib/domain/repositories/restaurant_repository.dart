// lib/domain/repositories/restaurant_repository.dart
import '../entities/restaurant.dart';

abstract class RestaurantRepository {
  Future<List<Restaurant>> getRestaurantRecommendations(
    double userLat,
    double userLon, {
    int limit,
    int offset,
    double? radius,
  });

  Future<List<Restaurant>> searchRestaurants(
    String query, {
    int? limit,
    int? offset,
    double? userLat,
    double? userLon,
  });

  Future<Restaurant?> getRestaurantById(int id);

  Future<bool> addRestaurant(Restaurant restaurant);

  Future<bool> updateRestaurant(Restaurant restaurant);

  Future<bool> deleteRestaurant(int id);
}
