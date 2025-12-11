import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/app_colors.dart';

class CurvedBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CurvedBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Shadow Layer (behind the clipped bar)
        Container(
          height: 70.h,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withOpacity(
                        0.3,
                      ) // Stronger shadow for dark mode
                    : Colors.black.withOpacity(0.06),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, -3),
              ),
            ],
          ),
        ),
        // Bottom Navigation Bar with Notch
        ClipPath(
          clipper: BottomNavClipper(),
          child: Container(
            height: 70.h,
            color: isDarkMode
                ? const Color(0xFF1F2937)
                : Colors.white, // Dark surface or white
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Home Button
                Expanded(
                  child: _buildNavItem(
                    context,
                    icon: Icons.home_rounded,
                    label: 'Home',
                    index: 0,
                    isDarkMode: isDarkMode,
                  ),
                ),
                // Empty space for floating button
                SizedBox(width: 70.w),
                // About Button
                Expanded(
                  child: _buildNavItem(
                    context,
                    icon: Icons.info_rounded,
                    label: 'About',
                    index: 2,
                    isDarkMode: isDarkMode,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Floating Search Button
        Positioned(
          bottom: 35.h,
          child: GestureDetector(
            onTap: () => onItemTapped(1),
            child: Container(
              width: 58.w,
              height: 58.w,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(Icons.search, color: Colors.white, size: 28.sp),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required bool isDarkMode,
  }) {
    final isSelected = selectedIndex == index;
    // Determine unselected color based on theme
    final unselectedColor = isDarkMode ? Colors.white54 : AppColors.textMuted;

    return InkWell(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primary : unselectedColor,
            size: 26.sp,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AppColors.primary : unselectedColor,
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Adjusted radius and geometry to perfectly cup the button
    final double notchRadius = 40.0;
    final double center = size.width / 2;

    path.lineTo(center - notchRadius * 1.8, 0);

    // Precise cubic bezier for a smoother, wider waterdrop shape
    // that creates a perfect negative space for the circle
    path.cubicTo(
      center - notchRadius,
      0, // Control point 1 (start of curve)
      center - notchRadius * 0.6,
      notchRadius * 0.8, // Control point 2 (going down)
      center,
      notchRadius * 0.8, // End point (bottom center)
    );

    path.cubicTo(
      center + notchRadius * 0.6,
      notchRadius * 0.8, // Control point 1 (going up)
      center + notchRadius,
      0, // Control point 2 (end of curve)
      center + notchRadius * 1.8,
      0, // End point
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
