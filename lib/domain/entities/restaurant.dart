// lib/domain/entities/restaurant.dart
import 'package:json_annotation/json_annotation.dart';

part 'restaurant.g.dart';

@JsonSerializable()
class Restaurant {
  final int id;
  final String name;
  final String? description;
  final String address;
  final double latitude;
  final double longitude;
  final String? phone;
  final String? cuisineType;
  final double rating;
  final int reviewCount;
  final String? imageUrl;
  final double? distance; // Distance from user's location (calculated)

  Restaurant({
    required this.id,
    required this.name,
    this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.phone,
    this.cuisineType,
    required this.rating,
    required this.reviewCount,
    this.imageUrl,
    this.distance,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => _$RestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}