import '../entities/restaurant.dart';
import '../repositories/restaurant_repository.dart';

class SearchRestaurants {
  final RestaurantRepository repository;

  SearchRestaurants(this.repository);

  Future<List<Restaurant>> execute(
    String query, {
    int? limit,
    int? offset,
    double? userLat,
    double? userLon,
  }) {
    return repository.searchRestaurants(
      query,
      limit: limit,
      offset: offset,
      userLat: userLat,
      userLon: userLon,
    );
  }
}
