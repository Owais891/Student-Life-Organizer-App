import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryPurple = Color(0xFF6C5CE7);
  static const Color secondaryPurple = Color(0xFFA29BFE);
  static const Color primaryBlue = Color(0xFF0984E3);
  static const Color accentCyan = Color(0xFF00CEC9);
  
  static const Color priorityHigh = Color(0xFFFF7675);
  static const Color priorityMedium = Color(0xFFFDCB6E);
  static const Color priorityLow = Color(0xFF00B894);

  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E2C);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPurple, primaryBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [secondaryPurple, accentCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
