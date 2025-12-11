import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/app_colors.dart';
import '../../domain/entities/restaurant.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final int index;
  final VoidCallback? onTap;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    this.index = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final gradient =
        AppColors.cardGradients[index % AppColors.cardGradients.length];
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isDarkMode
              ? const Color(0xFF1F2937)
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: isDarkMode
              ? [] // No shadow in dark mode for cleaner look
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child:
                  restaurant.imageUrl != null && restaurant.imageUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: CachedNetworkImage(
                        imageUrl: restaurant.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: isDarkMode ? Colors.white12 : Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.restaurant,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                    )
                  : Icon(Icons.restaurant, color: Colors.white, size: 24.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    restaurant.distance != null
                        ? '${restaurant.distance!.toStringAsFixed(1)} km'
                        : restaurant.cuisineType ?? 'Kuliner Makassar',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDarkMode
                          ? Colors.white70
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: AppColors.star, size: 16.sp),
                SizedBox(width: 4.w),
                Text(
                  restaurant.rating.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDarkMode
                        ? Colors.white70
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
