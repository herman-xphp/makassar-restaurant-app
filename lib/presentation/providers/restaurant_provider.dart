// lib/presentation/providers/restaurant_provider.dart
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/usecases/get_restaurant_recommendations.dart';
import '../../domain/usecases/search_restaurants.dart';

class RestaurantProvider extends ChangeNotifier {
  final GetRestaurantRecommendations getRestaurantRecommendations;
  final SearchRestaurants searchRestaurantsUseCase;

  RestaurantProvider({
    required this.getRestaurantRecommendations,
    required this.searchRestaurantsUseCase,
  });

  List<Restaurant> _restaurants = [];
  List<Restaurant> get restaurants => _restaurants;

  List<Restaurant> _searchResults = [];
  List<Restaurant> get searchResults => _searchResults;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  bool _hasMoreRestaurants = true;
  bool get hasMoreRestaurants => _hasMoreRestaurants;

  bool _hasMoreSearchResults = true;
  bool get hasMoreSearchResults => _hasMoreSearchResults;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  int _currentPage = 1;
  final int _pageSize = 10;

  Position? _lastPosition;

  double _selectedRadius = 10.0; // Default radius 10km
  double get selectedRadius => _selectedRadius;

  final List<double> _radiusOptions = [1.0, 5.0, 10.0];
  List<double> get radiusOptions => _radiusOptions;

  void setRadius(double radius) {
    if (_selectedRadius != radius) {
      _selectedRadius = radius;
      notifyListeners();
      // Automatically refresh restaurants with new radius
      if (_lastPosition != null) {
        getRestaurantRecommendationsByLocation(radius: radius);
      }
    }
  }

  Future<void> getRestaurantRecommendationsByLocation({
    int limit = 10,
    double radius = 10.0,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    _currentPage = 1;
    _hasMoreRestaurants = true;
    notifyListeners();

    try {
      // Get user's current location
      final position = await _determinePosition();
      _lastPosition = position;

      // Get restaurant recommendations based on current location
      _restaurants = await getRestaurantRecommendations.execute(
        position.latitude,
        position.longitude,
        limit: _pageSize,
        radius: radius,
      );

      // Check if there might be more results
      _hasMoreRestaurants = _restaurants.length >= _pageSize;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreRestaurants({double? radius}) async {
    if (_isLoadingMore || !_hasMoreRestaurants || _lastPosition == null) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      final offset = (_currentPage - 1) * _pageSize;

      final newRestaurants = await getRestaurantRecommendations.execute(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        limit: _pageSize,
        offset: offset,
        radius: radius ?? _selectedRadius,
      );

      _restaurants.addAll(newRestaurants);
      _hasMoreRestaurants = newRestaurants.length >= _pageSize;
    } catch (e) {
      debugPrint('Error loading more restaurants: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> getRestaurantRecommendationsByCoordinates(
    double latitude,
    double longitude, {
    int limit = 10,
    double radius = 10.0,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _restaurants = await getRestaurantRecommendations.execute(
        latitude,
        longitude,
        limit: limit,
        radius: radius,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _lastSearchQuery = '';
  double? _lastSearchLat;
  double? _lastSearchLon;

  Future<void> searchRestaurants(String query) async {
    _isLoading = true;
    _errorMessage = '';
    _currentPage = 1;
    _hasMoreSearchResults = true;
    _lastSearchQuery = query;
    notifyListeners();

    try {
      // Try to get user location for distance calculation
      double? userLat;
      double? userLon;

      try {
        final position = await _determinePosition();
        userLat = position.latitude;
        userLon = position.longitude;
        _lastSearchLat = userLat;
        _lastSearchLon = userLon;
      } catch (e) {
        // If location fails, continue search without distance
        debugPrint('Could not get location for search: $e');
      }

      _searchResults = await searchRestaurantsUseCase.execute(
        query,
        limit: _pageSize,
        userLat: userLat,
        userLon: userLon,
      );

      _hasMoreSearchResults = _searchResults.length >= _pageSize;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreSearchResults() async {
    if (_isLoadingMore || !_hasMoreSearchResults || _lastSearchQuery.isEmpty)
      return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      final offset = (_currentPage - 1) * _pageSize;

      final newResults = await searchRestaurantsUseCase.execute(
        _lastSearchQuery,
        limit: _pageSize,
        offset: offset,
        userLat: _lastSearchLat,
        userLon: _lastSearchLon,
      );

      _searchResults.addAll(newResults);
      _hasMoreSearchResults = newResults.length >= _pageSize;
    } catch (e) {
      debugPrint('Error loading more search results: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      throw Exception(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
