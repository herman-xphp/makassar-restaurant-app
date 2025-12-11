// lib/data/models/restaurant_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../../core/config.dart';
import '../../domain/entities/restaurant.dart';

part 'restaurant_model.g.dart';

@JsonSerializable()
class RestaurantModel extends Restaurant {
  RestaurantModel({
    required super.id,
    required super.name,
    super.description,
    required super.address,
    required super.latitude,
    required super.longitude,
    super.phone,
    super.cuisineType,
    required super.rating,
    required super.reviewCount,
    super.imageUrl,
    super.distance,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      address: json['address'] as String,
      latitude: json['latitude'] is String
          ? double.parse(json['latitude'])
          : (json['latitude'] as num).toDouble(),
      longitude: json['longitude'] is String
          ? double.parse(json['longitude'])
          : (json['longitude'] as num).toDouble(),
      phone: json['phone'] as String?,
      cuisineType:
          json['cuisine_type'] as String? ?? json['cuisineType'] as String?,
      rating: json['rating'] is String
          ? double.parse(json['rating'])
          : (json['rating'] as num).toDouble(),
      reviewCount: json['review_count'] is String
          ? int.parse(json['review_count'])
          : (json['review_count'] as num?)?.toInt() ??
                (json['reviewCount'] as num?)?.toInt() ??
                0,
      imageUrl: json['image_url'] != null
          ? (json['image_url'] as String).startsWith('http')
                ? json['image_url'] as String
                : (json['image_url'] as String).startsWith('/storage/')
                ? '${Config.baseUrl}/api/restaurants${json['image_url']}'
                : '${Config.baseUrl}/api/restaurants/storage/${json['image_url']}'
          : json['imageUrl'] as String?,
      distance: json['distance'] != null
          ? (json['distance'] is String
                ? double.parse(json['distance'])
                : (json['distance'] as num).toDouble())
          : null,
    );
  }

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);

  Restaurant toEntity() {
    return Restaurant(
      id: id,
      name: name,
      description: description,
      address: address,
      latitude: latitude,
      longitude: longitude,
      phone: phone,
      cuisineType: cuisineType,
      rating: rating,
      reviewCount: reviewCount,
      imageUrl: imageUrl,
      distance: distance,
    );
  }

  static RestaurantModel fromEntity(Restaurant entity) {
    return RestaurantModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      address: entity.address,
      latitude: entity.latitude,
      longitude: entity.longitude,
      phone: entity.phone,
      cuisineType: entity.cuisineType,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      imageUrl: entity.imageUrl,
      distance: entity.distance,
    );
  }
}
