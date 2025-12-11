// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/app_colors.dart';
import 'data/datasources/restaurant_remote_data_source.dart';
import 'data/datasources/restaurant_remote_data_source_impl.dart';
import 'data/repositories/restaurant_repository_impl.dart';
import 'domain/repositories/restaurant_repository.dart';
import 'domain/usecases/get_restaurant_recommendations.dart';
import 'domain/usecases/search_restaurants.dart';
import 'presentation/providers/restaurant_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/views/splash_screen.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider<http.Client>(create: (_) => http.Client()),
        ProxyProvider<http.Client, RestaurantRemoteDataSource>(
          update: (_, client, __) =>
              RestaurantRemoteDataSourceImpl(client: client),
        ),
        ProxyProvider<RestaurantRemoteDataSource, RestaurantRepository>(
          update: (_, remoteDataSource, __) =>
              RestaurantRepositoryImpl(remoteDataSource: remoteDataSource),
        ),
        ProxyProvider<RestaurantRepository, GetRestaurantRecommendations>(
          update: (_, repository, __) =>
              GetRestaurantRecommendations(repository),
        ),
        ProxyProvider<RestaurantRepository, SearchRestaurants>(
          update: (_, repository, __) => SearchRestaurants(repository),
        ),
        ChangeNotifierProvider(
          create: (context) => RestaurantProvider(
            getRestaurantRecommendations:
                Provider.of<GetRestaurantRecommendations>(
                  context,
                  listen: false,
                ),
            searchRestaurantsUseCase: Provider.of<SearchRestaurants>(
              context,
              listen: false,
            ),
          ),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812), // iPhone 12 Pro Max as example
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                title: 'Makassar Restaurant',
                debugShowCheckedModeBanner: false,
                themeMode: themeProvider.themeMode,
                theme: ThemeData(
                  primaryColor: AppColors.primary,
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: AppColors.primary,
                    primary: AppColors.primary,
                    brightness: Brightness.light,
                  ),
                  scaffoldBackgroundColor: AppColors.background,
                  useMaterial3: true,
                  fontFamily: 'Figtree',
                ),
                darkTheme: ThemeData(
                  primaryColor: AppColors.primary,
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: AppColors.primary,
                    primary: AppColors.primary,
                    brightness: Brightness.dark,
                  ),
                  scaffoldBackgroundColor: const Color(0xFF111827), // gray-900
                  useMaterial3: true,
                  fontFamily: 'Figtree',
                ),
                home: const SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
