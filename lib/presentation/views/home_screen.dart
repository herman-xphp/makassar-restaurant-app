import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/app_colors.dart';
import '../providers/restaurant_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/restaurant_card.dart';
import 'restaurant_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<RestaurantProvider>(context, listen: false);
      provider.getRestaurantRecommendationsByLocation(
        radius: provider.selectedRadius,
      );
    });

    // Add scroll listener
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      // Load more when scrolled 80% to bottom
      Provider.of<RestaurantProvider>(
        context,
        listen: false,
      ).loadMoreRestaurants();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access current theme
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildHeader(isDarkMode),
          Expanded(child: _buildContent(isDarkMode)),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return ClipPath(
      clipper: HomeHeaderClipper(),
      child: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? const LinearGradient(
                  colors: [
                    Color(0xFF0F392B),
                    Color(0xFF064E3B),
                  ], // Darker Green
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : AppColors.primaryGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 60.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Makassar Restaurant',
                          style: TextStyle(
                            fontSize: 20.sp, // Adjusted font size
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.white.withOpacity(0.9),
                              size: 14.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Makassar, Indonesia',
                              style: TextStyle(
                                fontSize: 12.sp, // Adjusted font size
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Theme Switch Button
                    Consumer<ThemeProvider>(
                      builder: (context, themeProvider, child) {
                        return GestureDetector(
                          onTap: () => themeProvider.toggleTheme(),
                          child: Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                themeProvider.isDarkMode
                                    ? Icons.light_mode
                                    : Icons.dark_mode,
                                key: ValueKey(themeProvider.isDarkMode),
                                color: Colors.white,
                                size: 22.sp,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool isDarkMode) {
    return Consumer<RestaurantProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            // Persistent Header with Radius Filter
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RESTORAN TERDEKAT',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode
                          ? Colors.white70
                          : AppColors.textSecondary,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _buildRadiusFilter(provider, isDarkMode),
                ],
              ),
            ),

            // Content State
            Expanded(child: _buildContentState(provider, isDarkMode)),
          ],
        );
      },
    );
  }

  Widget _buildContentState(RestaurantProvider provider, bool isDarkMode) {
    if (provider.isLoading && provider.restaurants.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 16.h),
            Text(
              'Memuat restoran...',
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (provider.errorMessage.isNotEmpty && provider.restaurants.isEmpty) {
      return _buildErrorState(provider, isDarkMode);
    }

    if (provider.restaurants.isEmpty) {
      return _buildEmptyState(provider, isDarkMode);
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => provider.getRestaurantRecommendationsByLocation(
        radius: provider.selectedRadius,
      ),
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        itemCount: provider.restaurants.length + 1, // +1 for loading indicator
        itemBuilder: (context, index) {
          // Loading Indicator at the bottom
          if (index == provider.restaurants.length) {
            return provider.isLoadingMore
                ? Padding(
                    padding: EdgeInsets.all(16.h),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  )
                : SizedBox(height: 80.h);
          }

          final restaurant = provider.restaurants[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: RestaurantCard(
              restaurant: restaurant,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RestaurantDetailScreen(restaurant: restaurant),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildRadiusFilter(RestaurantProvider provider, bool isDarkMode) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: provider.radiusOptions.length,
        separatorBuilder: (context, index) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final radius = provider.radiusOptions[index];
          final isSelected = provider.selectedRadius == radius;

          return GestureDetector(
            onTap: () => provider.setRadius(radius),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.primaryGradient : null,
                color: isSelected
                    ? null
                    : (isDarkMode
                          ? Colors.white.withOpacity(0.05)
                          : Colors.white),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : (isDarkMode
                            ? Colors.white.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.2)),
                ),
              ),
              child: Center(
                child: Row(
                  children: [
                    if (isSelected) ...[
                      Icon(Icons.check, color: Colors.white, size: 14.sp),
                      SizedBox(width: 4.w),
                    ],
                    Text(
                      '${radius}km',
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : (isDarkMode
                                  ? Colors.white70
                                  : AppColors.textPrimary),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(RestaurantProvider provider, bool isDarkMode) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48.sp,
                color: AppColors.error,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Terjadi kesalahan',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              provider.errorMessage,
              style: TextStyle(
                fontSize: 14.sp,
                color: isDarkMode ? Colors.white70 : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => provider.getRestaurantRecommendationsByLocation(
                radius: provider.selectedRadius,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(RestaurantProvider provider, bool isDarkMode) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.05)
                    : AppColors.textMuted.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.restaurant_outlined,
                size: 48.sp,
                color: isDarkMode ? Colors.white70 : AppColors.textMuted,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Tidak ada restoran ditemukan',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Cobalah memperluas radius pencarian Anda\n(Saat ini: ${provider.selectedRadius}km)',
              style: TextStyle(
                fontSize: 14.sp,
                color: isDarkMode ? Colors.white70 : AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () => provider.getRestaurantRecommendationsByLocation(
                radius: provider.selectedRadius,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 2,
              ),
              child: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);

    // Broad smooth curve similar to About Page
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 40,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
