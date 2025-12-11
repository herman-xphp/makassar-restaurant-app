// lib/data/repositories/restaurant_repository_impl.dart
import '../../domain/entities/restaurant.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../datasources/restaurant_remote_data_source.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantRemoteDataSource remoteDataSource;

  RestaurantRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Restaurant>> getRestaurantRecommendations(
    double userLat,
    double userLon, {
    int limit = 10,
    int offset = 0,
    double? radius,
  }) async {
    final restaurantModels = await remoteDataSource
        .getRestaurantRecommendations(
          userLat,
          userLon,
          limit: limit,
          offset: offset,
          radius: radius,
        );
    return restaurantModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Restaurant>> searchRestaurants(
    String query, {
    int? limit,
    int? offset,
    double? userLat,
    double? userLon,
  }) async {
    final restaurantModels = await remoteDataSource.searchRestaurants(
      query,
      limit: limit,
      offset: offset,
      userLat: userLat,
      userLon: userLon,
    );
    return restaurantModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Restaurant?> getRestaurantById(int id) async {
    final restaurantModel = await remoteDataSource.getRestaurantById(id);
    return restaurantModel?.toEntity();
  }

  @override
  Future<bool> addRestaurant(Restaurant restaurant) async {
    // TODO: Implement add restaurant
    throw UnimplementedError();
  }

  @override
  Future<bool> updateRestaurant(Restaurant restaurant) async {
    // TODO: Implement update restaurant
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteRestaurant(int id) async {
    // TODO: Implement delete restaurant
    throw UnimplementedError();
  }
}
