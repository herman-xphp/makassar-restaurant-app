// lib/domain/usecases/get_restaurant_recommendations.dart
import '../entities/restaurant.dart';
import '../repositories/restaurant_repository.dart';

class GetRestaurantRecommendations {
  final RestaurantRepository repository;

  GetRestaurantRecommendations(this.repository);

  Future<List<Restaurant>> execute(
    double userLat,
    double userLon, {
    int limit = 10,
    int offset = 0,
    double? radius,
  }) async {
    return await repository.getRestaurantRecommendations(
      userLat,
      userLon,
      limit: limit,
      offset: offset,
      radius: radius,
    );
  }
}
