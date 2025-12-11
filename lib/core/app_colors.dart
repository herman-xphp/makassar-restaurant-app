import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF10B981); // emerald-500
  static const Color primaryDark = Color(0xFF059669); // emerald-600
  static const Color primaryLight = Color(0xFF34D399); // emerald-400
  static const Color teal = Color(0xFF14B8A6); // teal-500
  
  static const Color background = Color(0xFFF9FAFB); // gray-50
  static const Color cardBackground = Color(0xFFF3F4F6); // gray-100
  static const Color white = Colors.white;
  
  static const Color textPrimary = Color(0xFF1F2937); // gray-800
  static const Color textSecondary = Color(0xFF6B7280); // gray-500
  static const Color textMuted = Color(0xFF9CA3AF); // gray-400
  
  static const Color star = Color(0xFFFBBF24); // yellow-400
  static const Color error = Color(0xFFEF4444); // red-500
  
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, teal],
  );
  
  static const LinearGradient greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4ADE80), Color(0xFF14B8A6)], // green-400 to teal-500
  );
  
  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFC084FC), Color(0xFFF472B6)], // purple-400 to pink-500
  );
  
  static List<LinearGradient> cardGradients = [
    primaryGradient,
    greenGradient,
    purpleGradient,
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFB923C), Color(0xFFF87171)], // orange-400 to red-400
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF60A5FA), Color(0xFF818CF8)], // blue-400 to indigo-400
    ),
  ];
}
